module controller(
    input  logic clk,
    input  logic reset,
    input  logic [6:0] op,
    input  logic [2:0] funct3,
    input  logic funct7b5,
    input  logic Zero,

    output logic [1:0] ImmSrc,
    output logic [1:0] ALUSrcA, ALUSrcB,
    output logic [1:0] ResultSrc,
    output logic AdrSrc,
    output logic [2:0] ALUControl,
    output logic IRWrite, PCWrite,
    output logic RegWrite, MemWrite
);

    logic [1:0] ALUOp;
    logic Branch, PCUpdate;

    mainfsm fsm(
        clk, reset, op,
        ALUSrcA, ALUSrcB, ResultSrc,
        AdrSrc, IRWrite, RegWrite, MemWrite,
        ALUOp, Branch, PCUpdate
    );

    aludec ad(
        op[5], funct3, funct7b5, ALUOp, ALUControl
    );

    instrdec id(
        op, ImmSrc
    );

    assign PCWrite = PCUpdate | (Branch & Zero);

endmodule


module mainfsm(
    input  logic clk,
    input  logic reset,
    input  logic [6:0] op,

    output logic [1:0] ALUSrcA, ALUSrcB,
    output logic [1:0] ResultSrc,
    output logic AdrSrc,
    output logic IRWrite, RegWrite, MemWrite,
    output logic [1:0] ALUOp,
    output logic Branch, PCUpdate
);

    typedef enum logic [3:0] {
        FETCH    = 4'd0,
        DECODE   = 4'd1,
        MEMADR   = 4'd2,
        MEMREAD  = 4'd3,
        MEMWB    = 4'd4,
        MEMWRITE = 4'd5,
        EXECUTER = 4'd6,
        ALUWB    = 4'd7,
        EXECUTEI = 4'd8,
        JAL      = 4'd9,
        BEQ      = 4'd10
    } statetype;

    statetype state, nextstate;

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            state <= FETCH;
        else
            state <= nextstate;
    end

    always_comb begin
        case (state)
            FETCH:  nextstate = DECODE;

            DECODE: begin
                case (op)
                    7'b0000011: nextstate = MEMADR;    // lw
                    7'b0100011: nextstate = MEMADR;    // sw
                    7'b0110011: nextstate = EXECUTER;  // R-type
                    7'b0010011: nextstate = EXECUTEI;  // I-type ALU
                    7'b1100011: nextstate = BEQ;       // beq
                    7'b1101111: nextstate = JAL;       // jal
                    default:    nextstate = FETCH;
                endcase
            end

            MEMADR: begin
                if (op == 7'b0000011)
                    nextstate = MEMREAD;
                else
                    nextstate = MEMWRITE;
            end

            MEMREAD:  nextstate = MEMWB;
            MEMWB:    nextstate = FETCH;
            MEMWRITE: nextstate = FETCH;

            EXECUTER: nextstate = ALUWB;
            EXECUTEI: nextstate = ALUWB;
            JAL:      nextstate = ALUWB;
            ALUWB:    nextstate = FETCH;

            BEQ:      nextstate = FETCH;

            default:  nextstate = FETCH;
        endcase
    end

    always_comb begin
        // default values
        ALUSrcA   = 2'b00;
        ALUSrcB   = 2'b00;
        ResultSrc = 2'b00;
        AdrSrc    = 1'b0;
        IRWrite   = 1'b0;
        RegWrite  = 1'b0;
        MemWrite  = 1'b0;
        ALUOp     = 2'b00;
        Branch    = 1'b0;
        PCUpdate  = 1'b0;

        case (state)
            FETCH: begin
                AdrSrc    = 1'b0;
                IRWrite   = 1'b1;
                ALUSrcA   = 2'b00;
                ALUSrcB   = 2'b10;
                ALUOp     = 2'b00;
                ResultSrc = 2'b10;
                PCUpdate  = 1'b1;
            end

            DECODE: begin
                ALUSrcA = 2'b01;
                ALUSrcB = 2'b01;
                ALUOp   = 2'b00;
            end

            MEMADR: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01;
                ALUOp   = 2'b00;
            end

            MEMREAD: begin
                ResultSrc = 2'b00;
                AdrSrc    = 1'b1;
            end

            MEMWB: begin
                ResultSrc = 2'b01;
                RegWrite  = 1'b1;
            end

            MEMWRITE: begin
                ResultSrc = 2'b00;
                AdrSrc    = 1'b1;
                MemWrite  = 1'b1;
            end

            EXECUTER: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b00;
                ALUOp   = 2'b10;
            end

            EXECUTEI: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01;
                ALUOp   = 2'b10;
            end

            ALUWB: begin
                ResultSrc = 2'b00;
                RegWrite  = 1'b1;
            end

            JAL: begin
                ALUSrcA   = 2'b01;
                ALUSrcB   = 2'b10;
                ALUOp     = 2'b00;
                ResultSrc = 2'b00;
                PCUpdate  = 1'b1;
            end

            BEQ: begin
                ALUSrcA   = 2'b10;
                ALUSrcB   = 2'b00;
                ALUOp     = 2'b01;
                ResultSrc = 2'b00;
                Branch    = 1'b1;
            end
        endcase
    end

endmodule


module aludec(
    input  logic opb5,
    input  logic [2:0] funct3,
    input  logic funct7b5,
    input  logic [1:0] ALUOp,
    output logic [2:0] ALUControl
);

    logic RtypeSub;
    assign RtypeSub = funct7b5 & opb5;

    always_comb begin
        case (ALUOp)
            2'b00: ALUControl = 3'b010; // add
            2'b01: ALUControl = 3'b110; // subtract

            default: begin
                case (funct3)
                    3'b000: begin
                        if (RtypeSub)
                            ALUControl = 3'b110; // sub
                        else
                            ALUControl = 3'b010; // add/addi
                    end

                    3'b010: ALUControl = 3'b111; // slt
                    3'b110: ALUControl = 3'b001; // or
                    3'b111: ALUControl = 3'b000; // and

                    default: ALUControl = 3'b010;
                endcase
            end
        endcase
    end

endmodule


module instrdec(
    input  logic [6:0] op,
    output logic [1:0] ImmSrc
);

    always_comb begin
        case (op)
            7'b0110011: ImmSrc = 2'bxx; // R-type
            7'b0010011: ImmSrc = 2'b00; // I-type ALU
            7'b0000011: ImmSrc = 2'b00; // lw
            7'b0100011: ImmSrc = 2'b01; // sw
            7'b1100011: ImmSrc = 2'b10; // beq
            7'b1101111: ImmSrc = 2'b11; // jal
            default:    ImmSrc = 2'bxx;
        endcase
    end

endmodule
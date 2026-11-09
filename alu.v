// RV32I ALU
// op = {funct7[5], funct3}  (for LUI use ALU_PASSB)
module alu (
    input  wire [31:0] a, b,
    input  wire [3:0]  op,
    output reg  [31:0] result,
    output wire        zero,    // a == b (for BEQ/BNE) -- uses a-b compare
    output wire        lt,      // signed   a <  b (BLT/BGE)
    output wire        ltu      // unsigned a <  b (BLTU/BGEU)
);
    localparam ALU_ADD   = 4'b0000;
    localparam ALU_SUB   = 4'b1000;
    localparam ALU_SLL   = 4'b0001;
    localparam ALU_SLT   = 4'b0010;
    localparam ALU_SLTU  = 4'b0011;
    localparam ALU_XOR   = 4'b0100;
    localparam ALU_SRL   = 4'b0101;
    localparam ALU_SRA   = 4'b1101;
    localparam ALU_OR    = 4'b0110;
    localparam ALU_AND   = 4'b0111;
    localparam ALU_PASSB = 4'b1001;   // LUI

    wire [4:0] shamt = b[4:0];

    // Branch comparison flags (independent of op)
    assign zero = (a == b);
    assign lt   = ($signed(a) < $signed(b));
    assign ltu  = (a < b);

    always @(*) begin
        case (op)
            ALU_ADD:   result = a + b;
            ALU_SUB:   result = a - b;
            ALU_SLL:   result = a << shamt;
            ALU_SLT:   result = {31'b0, lt};
            ALU_SLTU:  result = {31'b0, ltu};
            ALU_XOR:   result = a ^ b;
            ALU_SRL:   result = a >> shamt;
            ALU_SRA:   result = $signed(a) >>> shamt;
            ALU_OR:    result = a | b;
            ALU_AND:   result = a & b;
            ALU_PASSB: result = b;
            default:   result = 32'b0;
        endcase
    end
endmodule

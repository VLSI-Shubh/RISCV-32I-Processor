module alu_control(
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input        funct7_5,      // instruction[30]
    output reg [3:0] ALUCtrl
);

always @(*) begin
    case (ALUOp)
        2'b00: ALUCtrl = 4'b0000;              // ADD (load/store, auipc)
        2'b01: ALUCtrl = 4'b0001;              // SUB (branches)

        2'b10: begin                           // R / I-type ALU ops
            case ({funct7_5, funct3})
                4'b0_000: ALUCtrl = 4'b0000;   // ADD / ADDI
                4'b1_000: ALUCtrl = 4'b0001;   // SUB
                4'b0_111: ALUCtrl = 4'b0010;   // AND / ANDI
                4'b0_110: ALUCtrl = 4'b0011;   // OR / ORI
                4'b0_100: ALUCtrl = 4'b0100;   // XOR / XORI
                4'b0_001: ALUCtrl = 4'b0101;   // SLL / SLLI
                4'b0_101: ALUCtrl = 4'b0110;   // SRL / SRLI
                4'b1_101: ALUCtrl = 4'b0111;   // SRA / SRAI
                4'b0_010: ALUCtrl = 4'b1000;   // SLT / SLTI
                4'b0_011: ALUCtrl = 4'b1001;   // SLTU / SLTIU
                default:  ALUCtrl = 4'b0000;
            endcase
        end

        2'b11: begin
            // Special ALUOp for LUI (and only LUI)
            ALUCtrl = 4'b1010;                 // PASS B (alu_out = B = imm_out)
        end

        default: ALUCtrl = 4'b0000;
    endcase
end

endmodule

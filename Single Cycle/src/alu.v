module alu (
    input [31:0] A,B,
    input [3:0] alu_ctrl,
    output reg [31:0] alu_out,
    output reg zero
);
    always @(*) begin
        case (alu_ctrl)
            4'd0: alu_out = A + B; //Add
            4'd1: alu_out = A - B; // Substract
            4'd2: alu_out = A & B; //AND
            4'd3: alu_out = A | B; // OR
            4'd4: alu_out = A ^ B; // XOR
            4'd5: alu_out = A << B[4:0]; //SLL
            4'd6: alu_out = A >> B[4:0]; //SRL
            4'd7: alu_out = $signed(A) >>> B[4:0]; //SRA
            4'd8: alu_out = $signed(A) < $signed(B) ? 32'b1 :32'b0; //SLT signed
            4'd9: alu_out = (A < B) ? 32'b1 : 32'b0;
            4'd10: alu_out = B; // PASS B (for LUI, if you decide to use ALU)                               
            default: alu_out = A + B;
        endcase
        zero = (alu_out == 32'b0);
    end
endmodule
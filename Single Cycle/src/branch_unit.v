module branch_unit (
    input        Branch,           // from control (opcode == 1100011)
    input  [2:0] funct3,           // instr[14:12]
    input  [31:0] rs1_data,        // from regfile
    input  [31:0] rs2_data,        // from regfile
    output       take_branch
);

    reg t;

    assign take_branch = t;

    always @(*) begin
        t = 1'b0;  // default: no branch

        if (Branch) begin
            case (funct3)
                3'b000: t = (rs1_data == rs2_data);                         // BEQ
                3'b001: t = (rs1_data != rs2_data);                         // BNE
                3'b100: t = ($signed(rs1_data) <  $signed(rs2_data));       // BLT
                3'b101: t = ($signed(rs1_data) >= $signed(rs2_data));       // BGE
                3'b110: t = (rs1_data < rs2_data);                          // BLTU
                3'b111: t = (rs1_data >= rs2_data);                         // BGEU
                default: t = 1'b0;
            endcase
        end
    end
endmodule
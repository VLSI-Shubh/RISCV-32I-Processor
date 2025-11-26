module imm(
    input  [31:0] instruction,
    output reg [31:0] imm_out
);
    wire [6:0] opcode = instruction[6:0];

    always @(*) begin
        case (opcode)
            // I-type: OP-IMM, LOAD, JALR
            7'b0010011,   // OP-IMM (ADDI, ANDI, ORI, etc.)
            7'b0000011,   // LOAD  (LB, LH, LW, LBU, LHU)
            7'b1100111:   // JALR
                imm_out = {{20{instruction[31]}}, instruction[31:20]};

            // S-type: STORE
            7'b0100011:
                imm_out = {{20{instruction[31]}},
                           instruction[31:25],
                           instruction[11:7]};

            // B-type: BRANCH
            7'b1100011:
                imm_out = {{19{instruction[31]}},
                           instruction[31],       // imm[12]
                           instruction[7],        // imm[11]
                           instruction[30:25],    // imm[10:5]
                           instruction[11:8],     // imm[4:1]
                           1'b0};                 // imm[0]

            // U-type: LUI / AUIPC
            7'b0110111,   // LUI
            7'b0010111:   // AUIPC
                imm_out = {instruction[31:12], 12'b0};

            // J-type: JAL
            7'b1101111:
                imm_out = {{11{instruction[31]}},
                           instruction[31],       // imm[20]
                           instruction[19:12],    // imm[19:12]
                           instruction[20],       // imm[11]
                           instruction[30:21],    // imm[10:1]
                           1'b0};                 // imm[0]

            default:
                imm_out = 32'b0;
        endcase
    end

endmodule

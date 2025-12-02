`timescale 1ns/1ns
`include "../../src/imm.v"

module imm_tb;

    reg  [31:0] instruction;
    wire [31:0] imm_out;

    imm dut (
        .instruction (instruction),
        .imm_out     (imm_out)
    );

    task run_case;
        input [31:0] instr_in;
        input [31:0] exp_imm;
    begin
        instruction = instr_in;
        #1;
        if (imm_out === exp_imm)
            $display("PASS: instr=%h imm=%h", instr_in, imm_out);
        else
            $display("FAIL: instr=%h imm=%h exp=%h",
                     instr_in, imm_out, exp_imm);
    end
    endtask

    initial begin
        $dumpfile("imm_waveform.vcd");
        $dumpvars(0, imm_tb);

        // I-type OP-IMM (ADDI style), imm = 0x7FF -> 0x000007FF
        // enc: {imm[11:0]=7FF, rs1=1, funct3=000, rd=2, opcode=0010011}
        run_case(32'h7ff0_8113, 32'h0000_07ff);

        // I-type LOAD, imm = -8 -> 0xFFFFFFF8
        // enc: imm=-8, rs1=2, funct3=010, rd=3, opcode=0000011
        run_case(32'hff81_2183, 32'hffff_fff8);

        // S-type STORE, imm = 0xF2A -> 0xFFFFFF2A
        // enc: imm=F2A split across [31:25] and [11:7]
        run_case(32'hf220_8523, 32'hffff_ff2a);

        // B-type BRANCH, imm = -4 -> 0xFFFFFFFC
        run_case(32'hfe20_8ee3, 32'hffff_fffc);

        // U-type LUI, imm[31:12] = ABCDE -> 0xABCDE000
        run_case(32'habcd_e0b7, 32'habcd_e000);

        // J-type JAL, imm = 0x1578 -> 0x00001578
        run_case(32'h5780_10ef, 32'h0000_1578);

        // Default case: opcode not recognized -> 0
        run_case(32'h0000_0000, 32'h0000_0000);

        #5;
        $finish;
    end

endmodule

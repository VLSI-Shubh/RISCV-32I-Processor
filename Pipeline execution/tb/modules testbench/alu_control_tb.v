`timescale 1ns/1ns
`include "../../src/alu_control.v"

module alu_control_tb;

    reg  [1:0] ALUOp;
    reg  [2:0] funct3;
    reg        funct7_5;
    wire [3:0] ALUCtrl;

    alu_control dut (
        .ALUOp   (ALUOp),
        .funct3  (funct3),
        .funct7_5(funct7_5),
        .ALUCtrl (ALUCtrl)
    );

    task run_case;
        input [1:0] ALUOp_in;
        input [2:0] funct3_in;
        input       funct7_5_in;
        input [3:0] exp_ctrl;
    begin
        ALUOp    = ALUOp_in;
        funct3   = funct3_in;
        funct7_5 = funct7_5_in;
        #1;
        if (ALUCtrl === exp_ctrl)
            $display("PASS: ALUOp=%b funct7_5=%b funct3=%b -> %b",
                     ALUOp_in, funct7_5_in, funct3_in, ALUCtrl);
        else
            $display("FAIL: ALUOp=%b funct7_5=%b funct3=%b -> %b exp=%b",
                     ALUOp_in, funct7_5_in, funct3_in, ALUCtrl, exp_ctrl);
    end
    endtask

    initial begin
        $dumpfile("alu_control_waveform.vcd");
        $dumpvars(0, alu_control_tb);

        // ALUOp = 00 (load/store/auipc): ADD
        run_case(2'b00, 3'b000, 1'b0, 4'b0000);

        // ALUOp = 01 (branches): SUB
        run_case(2'b01, 3'b000, 1'b0, 4'b0001);

        // ALUOp = 10, R/I-type:
        run_case(2'b10, 3'b000, 1'b0, 4'b0000); // ADD/ADDI
        run_case(2'b10, 3'b000, 1'b1, 4'b0001); // SUB
        run_case(2'b10, 3'b111, 1'b0, 4'b0010); // AND
        run_case(2'b10, 3'b110, 1'b0, 4'b0011); // OR
        run_case(2'b10, 3'b100, 1'b0, 4'b0100); // XOR
        run_case(2'b10, 3'b001, 1'b0, 4'b0101); // SLL
        run_case(2'b10, 3'b101, 1'b0, 4'b0110); // SRL
        run_case(2'b10, 3'b101, 1'b1, 4'b0111); // SRA
        run_case(2'b10, 3'b010, 1'b0, 4'b1000); // SLT
        run_case(2'b10, 3'b011, 1'b0, 4'b1001); // SLTU

        // ALUOp = 11: LUI => PASS B (ctrl=1010)
        run_case(2'b11, 3'b000, 1'b0, 4'b1010);

        #5;
        $finish;
    end

endmodule

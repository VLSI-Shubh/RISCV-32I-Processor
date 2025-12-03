`timescale 1ns/1ns
`include "../../src/control.v"

module control_tb;

    reg  [6:0] opcode;
    wire RegWrite, MemRead, MemWrite, MemToReg, ALUSrc, Branch;
    wire [1:0] ALUOp;

    control dut (
        .opcode   (opcode),
        .RegWrite (RegWrite),
        .MemRead  (MemRead),
        .MemWrite (MemWrite),
        .MemToReg (MemToReg),
        .ALUSrc   (ALUSrc),
        .Branch   (Branch),
        .ALUOp    (ALUOp)
    );

    // pack all control signals to compare in one go
    task run_case;
        input [6:0] opcode_in;
        input [7:0] exp_ctrl; // {ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp[1:0]}
        reg   [7:0] act_ctrl;
    begin
        opcode = opcode_in;
        #1; // combinational settle

        act_ctrl = {ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp};

        if (act_ctrl === exp_ctrl)
            $display("PASS: opcode=%b ctrl=%b", opcode_in, act_ctrl);
        else
            $display("FAIL: opcode=%b got=%b exp=%b",
                     opcode_in, act_ctrl, exp_ctrl);
    end
    endtask

    initial begin
        $dumpfile("control_waveform.vcd");
        $dumpvars(0, control_tb);

        // R-type: 0110011 -> {0,0,1,0,0,0,10}
        run_case(7'b0110011, 8'b0_0_1_0_0_0_10);

        // I-type: 0010011
        run_case(7'b0010011, 8'b1_0_1_0_0_0_10);

        // Load: 0000011
        run_case(7'b0000011, 8'b1_1_1_1_0_0_00);

        // Store: 0100011
        run_case(7'b0100011, 8'b1_0_0_0_1_0_00);

        // Branch: 1100011
        run_case(7'b1100011, 8'b0_0_0_0_0_1_11);

        // Jump (JAL): 1101111
        run_case(7'b1101111, 8'b0_0_1_0_0_0_10);

        // LUI: 0110111
        run_case(7'b0110111, 8'b1_0_1_0_0_0_11);

        // Default: something unsupported
        run_case(7'b0000000, 8'b0_0_0_0_0_0_00);

        #5;
        $finish;
    end

endmodule

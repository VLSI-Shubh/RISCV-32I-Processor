`timescale 1ns/1ns
`include "../../src/core_sc.v"
`include "../../src/adder.v"
`include "../../src/alu_control.v"
`include "../../src/alu.v"
`include "../../src/control.v"
`include "../../src/imm.v"
`include "../../src/inst_mem.v"
`include "../../src/mux.v"
`include "../../src/pc.v"
`include "../../src/reg_file.v"
`include "../../src/branch_unit.v"


module core_sc_tb;

    reg clk;
    reg rst;

    core_sc uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;   // 50 MHz
    end

    // Reset and run
    initial begin
        rst = 1'b1;
        #50;
        rst = 1'b0;

        // Run for some cycles
        #1000;
        $finish;
    end

    // Waveform
    initial begin
        $dumpfile("core_sc_waveform.vcd");
        $dumpvars(0, core_sc_tb);
    end

endmodule

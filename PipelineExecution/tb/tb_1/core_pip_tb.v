`timescale 1ns/1ns
`include "../../core/core_pip.v"
`include "../../../Single Cycle/src/adder.v"
`include "../../../Single Cycle/src/alu_control.v"
`include "../../../Single Cycle/src/alu.v"
`include "../../../Single Cycle/src/control.v"
`include "../../../Single Cycle/src/imm.v"
`include "../../../Single Cycle/src/inst_mem.v"
`include "../../../Single Cycle/src/mux.v"
`include "../../../Single Cycle/src/pc.v"
`include "../../../Single Cycle/src/reg_file.v"
`include "../../../Single Cycle/src/branch_unit.v"
`include "../../stages/fetch.v"
`include "../../stages/decode.v"
`include "../../stages/execute.v"
`include "../../stages/memory.v"
`include "../../stages/if_id_reg.v"
`include "../../stages/id_ex_reg.v"
`include "../../stages/ex_mem_reg.v"
`include "../../stages/mem_wb_reg.v"
`include "../../stages/hazard_unit.v"
`include "../../stages/forwarding_unit.v"


module core_pip_tb;

    reg clk;
    reg rst;

    // DUT
    core_pip dut (
        .clk (clk),
        .rst (rst)
    );

    // Clock: 10 ns period
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Reset sequence
    initial begin
        rst = 1'b1;
        #20;
        rst = 1'b0;
    end

    // VCD dump for waveform viewing
    initial begin
        $dumpfile("core_pip_tb.vcd");
        $dumpvars(0, core_pip_tb);
    end

    // Run for fixed number of cycles then stop
    initial begin
        // Wait until reset is deasserted
        @(negedge rst);

        // Let the pipeline run for some time
        repeat (100) @(posedge clk);

        $finish;
    end

endmodule

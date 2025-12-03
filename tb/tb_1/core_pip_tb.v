`timescale 1ns/1ns
`include "../../src/core_pip.v"
`include "../../src/modules/adder.v"
`include "../../src/modules/alu_control.v"
`include "../../src/modules/alu.v"
`include "../../src/modules/control.v"
`include "../../src/modules/imm.v"
`include "../../src/modules/inst_mem.v"
`include "../../src/modules/mux.v"
`include "../../src/modules/pc.v"
`include "../../src/modules/reg_file.v"
`include "../../src/modules/branch_unit.v"
`include "../../src/stages/fetch.v"
`include "../../src/stages/decode.v"
`include "../../src/stages/execute.v"
`include "../../src/stages/memory.v"
`include "../../src/stages/if_id_reg.v"
`include "../../src/stages/id_ex_reg.v"
`include "../../src/stages/ex_mem_reg.v"
`include "../../src/stages/mem_wb_reg.v"
`include "../../src/stages/hazard_unit.v"
`include "../../src/stages/forwarding_unit.v"


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

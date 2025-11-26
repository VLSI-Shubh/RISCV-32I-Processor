`timescale 1ns/1ns
`include "../../src/inst_mem.v"   // <-- update path to your inst_mem.v

module inst_mem_tb;

    reg  [31:0] read_address;
    wire [31:0] instruction_out;

    inst_mem dut (
        .read_address   (read_address),
        .instruction_out(instruction_out)
    );

    task run_case;
        input [31:0] addr;
        input [31:0] exp_instr;
    begin
        read_address = addr;
        #1;  // allow combinational read to settle

        if (instruction_out === exp_instr)
            $display("PASS: addr=%0d (0x%08h) -> instr=%08h",
                     addr, addr, instruction_out);
        else
            $display("FAIL: addr=%0d (0x%08h) -> instr=%08h exp=%08h",
                     addr, addr, instruction_out, exp_instr);
    end
    endtask

    initial begin
        $dumpfile("inst_mem_waveform.vcd");
        $dumpvars(0, inst_mem_tb);

        // Small delay to let $readmemh complete
        #1;

        // instruction.mem contents:
        // 0: 00000093
        // 1: 00400113
        // 2: 00208233
        // 3: 00412023
        // 4: 00412283
        // 5: 002102B3
        // 6: 00500313
        // 7: 006283B3
        // 8: 00712423
        // 9: 00812503

        run_case(32'd0,  32'h0000_0093);
        run_case(32'd4,  32'h0040_0113);
        run_case(32'd8,  32'h0020_8233);
        run_case(32'd12, 32'h0041_2023);
        run_case(32'd16, 32'h0041_2283);
        run_case(32'd20, 32'h0021_02b3);
        run_case(32'd24, 32'h0050_0313);
        run_case(32'd28, 32'h0062_83b3);
        run_case(32'd32, 32'h0071_2423);
        run_case(32'd36, 32'h0081_2503);

        // Optional: read some unused location
        run_case(32'd40, 32'hxxxx_xxxx); // expect X / uninitialized

        #5;
        $finish;
    end

endmodule

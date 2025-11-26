`timescale 1ns/1ns
`include "../../src/alu.v"

module alu_tb;

    reg  [31:0] A, B;
    reg  [3:0]  alu_ctrl;
    wire [31:0] alu_out;
    wire        zero;

    alu uut (
        .A        (A),
        .B        (B),
        .alu_ctrl (alu_ctrl),
        .alu_out  (alu_out),
        .zero     (zero)
    );

    // simple task for one test case
    task run_case;
        input [3:0]  ctrl;
        input [31:0] a_in, b_in;
        input [31:0] exp_out;
        input        exp_zero;
    begin
        A        = a_in;
        B        = b_in;
        alu_ctrl = ctrl;
        #10; // let combinational logic settle

        if (alu_out === exp_out && zero === exp_zero)
            $display("PASS: ctrl=%0d A=%h B=%h -> out=%h zero=%b",
                     ctrl, a_in, b_in, alu_out, zero);
        else begin
            $display("FAIL: ctrl=%0d A=%h B=%h -> out=%h zero=%b (exp %h %b)",
                     ctrl, a_in, b_in, alu_out, zero, exp_out, exp_zero);
        end
    end
    endtask

    initial begin
        $dumpfile("alu_waveform.vcd");
        $dumpvars(0, alu_tb);

        // initialize
        A = 0; B = 0; alu_ctrl = 0;
        #5;

        // ADD
        run_case(4'd0, 32'd10, 32'd5,  32'd15, 1'b0);

        // SUB
        run_case(4'd1, 32'd10, 32'd10, 32'd0,  1'b1);

        // AND
        run_case(4'd2, 32'hffff0000, 32'h0f0f0f0f, 32'h0f0f0000, 1'b0);

        // OR
        run_case(4'd3, 32'h0000ffff, 32'hf0f0f0f0, 32'hf0f0ffff, 1'b0);

        // XOR
        run_case(4'd4, 32'hff00ff00, 32'h0f0f0f0f, 32'hf00ff00f, 1'b0);

        // SLL
        run_case(4'd5, 32'h00000001, 32'd4,        32'h00000010, 1'b0);

        // SRL
        run_case(4'd6, 32'h00000080, 32'd4,        32'h00000008, 1'b0);

        // SRA (signed)
        run_case(4'd7, 32'hfffffff0, 32'd2,        32'hfffffffc, 1'b0);

        // SLT (signed)
        run_case(4'd8, -32'sd1,      32'sd5,       32'd1,        1'b0);
        run_case(4'd8,  32'sd10,     32'sd5,       32'd0,        1'b1);

        // SLTU (unsigned)
        run_case(4'd9, 32'h00000001, 32'hffffffff, 32'd1,        1'b0);
        run_case(4'd9, 32'hffffffff, 32'h00000001, 32'd0,        1'b1);

        // PASS_B
        run_case(4'd10, 32'h12345678, 32'hdeadbeef, 32'hdeadbeef, 1'b0);

        #10;
        $finish;
    end

endmodule

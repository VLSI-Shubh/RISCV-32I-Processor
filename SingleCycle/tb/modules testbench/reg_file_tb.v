`timescale 1ns/1ns
`include "../../src/reg_file.v"

module reg_file_tb;

    reg         clk;
    reg         rst;
    reg         RegWrite;
    reg  [4:0]  Rs1, Rs2, Rd;
    reg  [31:0] Write_data;
    wire [31:0] read_data1, read_data2;

    reg_file dut (
        .clk        (clk),
        .rst        (rst),
        .RegWrite   (RegWrite),
        .Rs1        (Rs1),
        .Rs2        (Rs2),
        .Rd         (Rd),
        .Write_data (Write_data),
        .read_data1 (read_data1),
        .read_data2 (read_data2)
    );

    // 10 ns clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("reg_file_waveform.vcd");
        $dumpvars(0, reg_file_tb);

        // ---- init ----
        rst        = 1'b1;
        RegWrite   = 1'b0;
        Rs1        = 5'd0;
        Rs2        = 5'd0;
        Rd         = 5'd0;
        Write_data = 32'd0;

        // two posedges with reset asserted
        @(posedge clk);
        @(posedge clk);
        rst = 1'b0;    // deassert reset

        // check after reset
        Rs1 = 5'd0;  #1;
        $display("After reset: x0 = %h (expect 00000000)", read_data1);
        Rs1 = 5'd5;  #1;
        $display("After reset: x5 = %h (expect 00000000)", read_data1);

        // ---- write x5 = 0xDEADBEEF ----
        @(posedge clk);
        RegWrite   <= 1'b1;
        Rd         <= 5'd5;
        Write_data <= 32'hdead_beef;

        @(posedge clk);   // write happens here
        RegWrite   <= 1'b0;

        // ---- write x10 = 0x12345678 ----
        @(posedge clk);
        RegWrite   <= 1'b1;
        Rd         <= 5'd10;
        Write_data <= 32'h1234_5678;

        @(posedge clk);   // write happens here
        RegWrite   <= 1'b0;

        // ---- read back and check ----
        Rs1 = 5'd5;   #1;
        if (read_data1 === 32'hdead_beef)
            $display("PASS: x5 = %h", read_data1);
        else
            $display("FAIL: x5 = %h exp=deadbeef", read_data1);

        Rs1 = 5'd10;  #1;
        if (read_data1 === 32'h1234_5678)
            $display("PASS: x10 = %h", read_data1);
        else
            $display("FAIL: x10 = %h exp=12345678", read_data1);

        // ---- try to write x0 (should still be 0) ----
        @(posedge clk);
        RegWrite   <= 1'b1;
        Rd         <= 5'd0;
        Write_data <= 32'hffff_ffff;

        @(posedge clk);
        RegWrite   <= 1'b0;

        Rs1 = 5'd0;  #1;
        if (read_data1 === 32'd0)
            $display("PASS: x0 still = %h", read_data1);
        else
            $display("FAIL: x0 = %h exp=00000000", read_data1);

        #10;
        $finish;
    end

endmodule

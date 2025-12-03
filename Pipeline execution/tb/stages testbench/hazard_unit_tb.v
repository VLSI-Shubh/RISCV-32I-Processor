`timescale 1ns/1ns
`include "../../src/stages/hazard_unit.v"

module hazard_unit_tb;

    reg        id_ex_memRead;
    reg [4:0]  id_ex_rd;
    reg [4:0]  if_id_rs1;
    reg [4:0]  if_id_rs2;

    wire       stall_pc;
    wire       stall_if_id;
    wire       flush_id_ex;

    integer errors;

    hazard_unit dut (
        .id_ex_memRead (id_ex_memRead),
        .id_ex_rd      (id_ex_rd),
        .if_id_rs1     (if_id_rs1),
        .if_id_rs2     (if_id_rs2),
        .stall_pc      (stall_pc),
        .stall_if_id   (stall_if_id),
        .flush_id_ex   (flush_id_ex)
    );

    task check_outputs;
        input exp_stall_pc;
        input exp_stall_if_id;
        input exp_flush_id_ex;
        begin
            if (stall_pc    !== exp_stall_pc   ||
                stall_if_id !== exp_stall_if_id||
                flush_id_ex !== exp_flush_id_ex) begin
                $display("ERROR time=%0t memRead=%0b rd=%0d rs1=%0d rs2=%0d : got (stall_pc=%0b, stall_if_id=%0b, flush_id_ex=%0b), expected (%0b,%0b,%0b)",
                         $time, id_ex_memRead, id_ex_rd, if_id_rs1, if_id_rs2,
                         stall_pc, stall_if_id, flush_id_ex,
                         exp_stall_pc, exp_stall_if_id, exp_flush_id_ex);
                errors = errors + 1;
            end else begin
                $display("OK    time=%0t memRead=%0b rd=%0d rs1=%0d rs2=%0d : (stall_pc=%0b, stall_if_id=%0b, flush_id_ex=%0b)",
                         $time, id_ex_memRead, id_ex_rd, if_id_rs1, if_id_rs2,
                         stall_pc, stall_if_id, flush_id_ex);
            end
        end
    endtask

    initial begin
        errors = 0;

        // Case 1: no load, no hazard
        id_ex_memRead = 1'b0;
        id_ex_rd      = 5'd5;
        if_id_rs1     = 5'd5;
        if_id_rs2     = 5'd0;
        #1;
        check_outputs(1'b0, 1'b0, 1'b0);

        // Case 2: load but rd == x0, should not stall
        id_ex_memRead = 1'b1;
        id_ex_rd      = 5'd0;
        if_id_rs1     = 5'd0;
        if_id_rs2     = 5'd0;
        #1;
        check_outputs(1'b0, 1'b0, 1'b0);

        // Case 3: load-use hazard on rs1
        id_ex_memRead = 1'b1;
        id_ex_rd      = 5'd10;
        if_id_rs1     = 5'd10;
        if_id_rs2     = 5'd0;
        #1;
        check_outputs(1'b1, 1'b1, 1'b1);

        // Case 4: load-use hazard on rs2
        id_ex_memRead = 1'b1;
        id_ex_rd      = 5'd7;
        if_id_rs1     = 5'd0;
        if_id_rs2     = 5'd7;
        #1;
        check_outputs(1'b1, 1'b1, 1'b1);

        // Case 5: no match on rs1/rs2
        id_ex_memRead = 1'b1;
        id_ex_rd      = 5'd3;
        if_id_rs1     = 5'd1;
        if_id_rs2     = 5'd2;
        #1;
        check_outputs(1'b0, 1'b0, 1'b0);

        if (errors == 0)
            $display("Hazard unit test completed with no errors.");
        else
            $display("Hazard unit test completed with %0d error(s).", errors);

        $finish;
    end

endmodule

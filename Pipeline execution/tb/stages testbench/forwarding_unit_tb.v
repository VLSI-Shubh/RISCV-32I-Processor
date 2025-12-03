`timescale 1ns/1ps
`include "../../src/stages/forwarding_unit.v"

module forwarding_unit_tb;

    reg [4:0] id_ex_rs1;
    reg [4:0] id_ex_rs2;

    reg [4:0] ex_mem_rd;
    reg       ex_mem_RegWrite;

    reg [4:0] mem_wb_rd;
    reg       mem_wb_RegWrite;

    wire [1:0] forwardA;
    wire [1:0] forwardB;

    integer errors;

    forwarding_unit dut (
        .id_ex_rs1       (id_ex_rs1),
        .id_ex_rs2       (id_ex_rs2),
        .ex_mem_rd       (ex_mem_rd),
        .ex_mem_RegWrite (ex_mem_RegWrite),
        .mem_wb_rd       (mem_wb_rd),
        .mem_wb_RegWrite (mem_wb_RegWrite),
        .forwardA        (forwardA),
        .forwardB        (forwardB)
    );

    task check_outputs;
        input [1:0] exp_forwardA;
        input [1:0] exp_forwardB;
        begin
            if (forwardA !== exp_forwardA || forwardB !== exp_forwardB) begin
                $display("ERROR time=%0t rs1=%0d rs2=%0d ex_mem(rd=%0d,RegW=%0b) mem_wb(rd=%0d,RegW=%0b): got (A=%b,B=%b), expected (A=%b,B=%b)",
                         $time, id_ex_rs1, id_ex_rs2,
                         ex_mem_rd, ex_mem_RegWrite,
                         mem_wb_rd, mem_wb_RegWrite,
                         forwardA, forwardB,
                         exp_forwardA, exp_forwardB);
                errors = errors + 1;
            end else begin
                $display("OK    time=%0t rs1=%0d rs2=%0d ex_mem(rd=%0d,RegW=%0b) mem_wb(rd=%0d,RegW=%0b): (A=%b,B=%b)",
                         $time, id_ex_rs1, id_ex_rs2,
                         ex_mem_rd, ex_mem_RegWrite,
                         mem_wb_rd, mem_wb_RegWrite,
                         forwardA, forwardB);
            end
        end
    endtask

    initial begin
        errors = 0;

        // Case 1: no matches, no forwarding
        id_ex_rs1       = 5'd1;
        id_ex_rs2       = 5'd2;
        ex_mem_rd       = 5'd0;
        ex_mem_RegWrite = 1'b0;
        mem_wb_rd       = 5'd0;
        mem_wb_RegWrite = 1'b0;
        #1;
        check_outputs(2'b00, 2'b00);

        // Case 2: EX hazard on rs1
        id_ex_rs1       = 5'd5;
        id_ex_rs2       = 5'd2;
        ex_mem_rd       = 5'd5;
        ex_mem_RegWrite = 1'b1;
        mem_wb_rd       = 5'd0;
        mem_wb_RegWrite = 1'b0;
        #1;
        check_outputs(2'b10, 2'b00);

        // Case 3: EX hazard on rs2
        id_ex_rs1       = 5'd1;
        id_ex_rs2       = 5'd7;
        ex_mem_rd       = 5'd7;
        ex_mem_RegWrite = 1'b1;
        mem_wb_rd       = 5'd0;
        mem_wb_RegWrite = 1'b0;
        #1;
        check_outputs(2'b00, 2'b10);

        // Case 4: MEM hazard on rs1 only
        id_ex_rs1       = 5'd8;
        id_ex_rs2       = 5'd9;
        ex_mem_rd       = 5'd0;
        ex_mem_RegWrite = 1'b0;
        mem_wb_rd       = 5'd8;
        mem_wb_RegWrite = 1'b1;
        #1;
        check_outputs(2'b01, 2'b00);

        // Case 5: MEM hazard on rs2 only
        id_ex_rs1       = 5'd3;
        id_ex_rs2       = 5'd4;
        ex_mem_rd       = 5'd0;
        ex_mem_RegWrite = 1'b0;
        mem_wb_rd       = 5'd4;
        mem_wb_RegWrite = 1'b1;
        #1;
        check_outputs(2'b00, 2'b01);

        // Case 6: EX and MEM both match rs1, EX should win
        id_ex_rs1       = 5'd10;
        id_ex_rs2       = 5'd0;
        ex_mem_rd       = 5'd10;
        ex_mem_RegWrite = 1'b1;
        mem_wb_rd       = 5'd10;
        mem_wb_RegWrite = 1'b1;
        #1;
        check_outputs(2'b10, 2'b00);

        // Case 7: EX and MEM both match rs2, EX should win
        id_ex_rs1       = 5'd0;
        id_ex_rs2       = 5'd11;
        ex_mem_rd       = 5'd11;
        ex_mem_RegWrite = 1'b1;
        mem_wb_rd       = 5'd11;
        mem_wb_RegWrite = 1'b1;
        #1;
        check_outputs(2'b00, 2'b10);

        if (errors == 0)
            $display("Forwarding unit test completed with no errors.");
        else
            $display("Forwarding unit test completed with %0d error(s).", errors);

        $finish;
    end

endmodule

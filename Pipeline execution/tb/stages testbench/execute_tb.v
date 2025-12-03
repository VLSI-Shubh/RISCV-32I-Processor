`timescale 1ns/1ps
`include "../../src/stages/execute.v"
`include "../../src/modules/alu.v"
`include "../../src/modules/alu_control.v"
`include "../../src/modules/branch_unit.v"
`include "../../src/modules/mux.v"
`include "../../src/modules/adder.v"

module execute_tb;

    // ID/EX inputs
    reg  [31:0] pc_in;
    reg  [31:0] rs1_data_in;
    reg  [31:0] rs2_data_in;
    reg  [31:0] imm_in;
    reg  [4:0]  rs1_in;
    reg  [4:0]  rs2_in;
    reg  [4:0]  rd_in;
    reg  [2:0]  funct3_in;
    reg         funct7_5_in;
    reg         RegWrite_in;
    reg         MemRead_in;
    reg         MemWrite_in;
    reg         MemToReg_in;
    reg         ALUSrc_in;
    reg         Branch_in;
    reg  [1:0]  ALUOp_in;

    // Forwarding inputs
    reg  [1:0]  forwardA;
    reg  [1:0]  forwardB;
    reg  [31:0] ex_mem_alu_result;
    reg  [31:0] wb_data;

    // Outputs from execute
    wire [31:0] alu_result_out;
    wire [31:0] rs2_data_forwarded_out;
    wire [4:0]  rd_out;
    wire        RegWrite_out;
    wire        MemRead_out;
    wire        MemWrite_out;
    wire        MemToReg_out;
    wire        branch_taken_out;
    wire [31:0] branch_target_out;

    integer errors;

    execute dut (
        .pc_in                 (pc_in),
        .rs1_data_in           (rs1_data_in),
        .rs2_data_in           (rs2_data_in),
        .imm_in                (imm_in),
        .rs1_in                (rs1_in),
        .rs2_in                (rs2_in),
        .rd_in                 (rd_in),
        .funct3_in             (funct3_in),
        .funct7_5_in           (funct7_5_in),
        .RegWrite_in           (RegWrite_in),
        .MemRead_in            (MemRead_in),
        .MemWrite_in           (MemWrite_in),
        .MemToReg_in           (MemToReg_in),
        .ALUSrc_in             (ALUSrc_in),
        .Branch_in             (Branch_in),
        .ALUOp_in              (ALUOp_in),
        .forwardA              (forwardA),
        .forwardB              (forwardB),
        .ex_mem_alu_result     (ex_mem_alu_result),
        .wb_data               (wb_data),
        .alu_result_out        (alu_result_out),
        .rs2_data_forwarded_out(rs2_data_forwarded_out),
        .rd_out                (rd_out),
        .RegWrite_out          (RegWrite_out),
        .MemRead_out           (MemRead_out),
        .MemWrite_out          (MemWrite_out),
        .MemToReg_out          (MemToReg_out),
        .branch_taken_out      (branch_taken_out),
        .branch_target_out     (branch_target_out)
    );

    task check_alu;
        input [31:0] exp_result;
        begin
            if (alu_result_out !== exp_result) begin
                $display("ERROR time=%0t: alu_result_out=%0d expected=%0d",
                         $time, alu_result_out, exp_result);
                errors = errors + 1;
            end else begin
                $display("OK    time=%0t: alu_result_out=%0d",
                         $time, alu_result_out);
            end
        end
    endtask

    task check_branch;
        input exp_taken;
        input [31:0] exp_target;
        begin
            if (branch_taken_out !== exp_taken ||
                branch_target_out !== exp_target) begin
                $display("ERROR time=%0t: branch_taken_out=%0b (exp %0b), branch_target_out=%0d (exp %0d)",
                         $time, branch_taken_out, exp_taken,
                         branch_target_out, exp_target);
                errors = errors + 1;
            end else begin
                $display("OK    time=%0t: branch_taken=%0b, branch_target=%0d",
                         $time, branch_taken_out, branch_target_out);
            end
        end
    endtask

    initial begin
        errors = 0;

        forwardA          = 2'b00;
        forwardB          = 2'b00;
        ex_mem_alu_result = 32'd0;
        wb_data           = 32'd0;

        // Test 1: R-type ADD (no forwarding)
        // Assumes ALUOp=2'b10, funct3=000, funct7_5=0 selects ADD
        pc_in        = 32'd100;
        rs1_data_in  = 32'd10;
        rs2_data_in  = 32'd20;
        imm_in       = 32'd0;
        rs1_in       = 5'd1;
        rs2_in       = 5'd2;
        rd_in        = 5'd3;
        funct3_in    = 3'b000;
        funct7_5_in  = 1'b0;
        RegWrite_in  = 1'b1;
        MemRead_in   = 1'b0;
        MemWrite_in  = 1'b0;
        MemToReg_in  = 1'b0;
        ALUSrc_in    = 1'b0;
        Branch_in    = 1'b0;
        ALUOp_in     = 2'b10;
        #1;
        check_alu(32'd30);

        // Test 2: I-type ADDI style (ALUSrc=1)
        rs1_data_in  = 32'd5;
        imm_in       = 32'd7;
        ALUSrc_in    = 1'b1;
        #1;
        check_alu(32'd12);

        // Test 3: forwarding from EX/MEM on operand A
        rs1_data_in       = 32'd0;
        rs2_data_in       = 32'd1;
        imm_in            = 32'd1;
        ex_mem_alu_result = 32'd42;
        forwardA          = 2'b10;
        forwardB          = 2'b00;
        ALUSrc_in         = 1'b1;
        #1;
        check_alu(32'd43);

        // Test 4: branch decision and target (BEQ taken)
        // Assumes funct3=000 indicates BEQ.
        pc_in        = 32'd200;
        rs1_data_in  = 32'd15;
        rs2_data_in  = 32'd15;
        imm_in       = 32'd16;     // branch offset (already shifted)
        funct3_in    = 3'b000;     // BEQ
        Branch_in    = 1'b1;
        forwardA     = 2'b00;
        forwardB     = 2'b00;
        ALUSrc_in    = 1'b0;
        #1;
        check_branch(1'b1, 32'd216); // 200 + 16

        if (errors == 0)
            $display("Execute stage test completed with no errors.");
        else
            $display("Execute stage test completed with %0d error(s).", errors);

        $finish;
    end

endmodule

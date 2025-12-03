// ======================================================
// Execute Stage (EX)
// - Reuses standard building blocks:
//     * alu_control
//     * alu
//     * branch_unit
//     * adder
//     * mux
// - Takes forwarding selections from forwarding_unit and
//   produces ALU result, branch decision, branch target,
//   and forwarded store data for the next stage.
// ======================================================
module execute (
    // From ID/EX pipeline register
    input  [31:0] pc_in,
    input  [31:0] rs1_data_in,
    input  [31:0] rs2_data_in,
    input  [31:0] imm_in,
    input  [4:0]  rs1_in,
    input  [4:0]  rs2_in,
    input  [4:0]  rd_in,
    input  [2:0]  funct3_in,
    input         funct7_5_in,

    input         RegWrite_in,
    input         MemRead_in,
    input         MemWrite_in,
    input         MemToReg_in,
    input         ALUSrc_in,
    input         Branch_in,
    input  [1:0]  ALUOp_in,

    // From forwarding unit
    input  [1:0]  forwardA,          // select for first ALU operand
    input  [1:0]  forwardB,          // select for second ALU operand
    input  [31:0] ex_mem_alu_result, // forwarded data from EX/MEM
    input  [31:0] wb_data,           // forwarded data from WB

    // Outputs to EX/MEM pipeline register
    output [31:0] alu_result_out,
    output [31:0] rs2_data_forwarded_out,
    output [4:0]  rd_out,
    output        RegWrite_out,
    output        MemRead_out,
    output        MemWrite_out,
    output        MemToReg_out,

    // Outputs to Fetch / top for control flow
    output        branch_taken_out,
    output [31:0] branch_target_out
);

    // --------------------------------------------------
    // 1) Forwarding muxes for ALU operands
    // --------------------------------------------------
    reg [31:0] opA;
    reg [31:0] opB;

    always @(*) begin
        opA = rs1_data_in;
        opB = rs2_data_in;

        // Forward for rs1
        case (forwardA)
            2'b10: opA = ex_mem_alu_result;
            2'b01: opA = wb_data;
            default: ;
        endcase

        // Forward for rs2
        case (forwardB)
            2'b10: opB = ex_mem_alu_result;
            2'b01: opB = wb_data;
            default: ;
        endcase
    end

    // --------------------------------------------------
    // 2) ALUSrc mux:
    //   0 -> use opB (register)
    //   1 -> use imm_in
    // --------------------------------------------------
    wire [31:0] alu_in1;
    wire [31:0] alu_in2;

    assign alu_in1 = opA;

    mux #(.width(32)) u_alu_src_mux (
        .in0 (opB),
        .in1 (imm_in),
        .sel (ALUSrc_in),
        .out (alu_in2)
    );

    // --------------------------------------------------
    // 3) ALU control (alu_control.v)
    // --------------------------------------------------
    wire [3:0] alu_ctrl;

    alu_control u_alu_control (
        .ALUOp    (ALUOp_in),
        .funct3   (funct3_in),
        .funct7_5 (funct7_5_in),
        .ALUCtrl  (alu_ctrl)
    );

    // --------------------------------------------------
    // 4) ALU (alu.v)
    // --------------------------------------------------
    wire [31:0] alu_result;
    wire        zero_flag;

    alu u_alu (
        .A        (alu_in1),
        .B        (alu_in2),
        .alu_ctrl (alu_ctrl),
        .alu_out  (alu_result),
        .zero     (zero_flag)
    );

    // --------------------------------------------------
    // 5) Branch unit (branch_unit.v)
    //    Uses forwarded register operands opA, opB.
// --------------------------------------------------
    wire branch_taken;

    branch_unit u_branch_unit (
        .Branch      (Branch_in),
        .funct3      (funct3_in),
        .rs1_data    (opA),
        .rs2_data    (opB),
        .take_branch (branch_taken)
    );

    assign branch_taken_out = branch_taken;

    // --------------------------------------------------
    // 6) Branch target address = pc_in + imm_in
    //    Uses the shared adder block for address calculation.
    // --------------------------------------------------
    wire [31:0] branch_target;

    adder #(.WIDTH(32)) u_branch_addr_adder (
        .a   (pc_in),
        .b   (imm_in),
        .sum (branch_target)
    );

    assign branch_target_out = branch_target;

    // --------------------------------------------------
    // 7) Outputs to EX/MEM pipeline register
    // --------------------------------------------------
    assign alu_result_out         = alu_result;
    assign rs2_data_forwarded_out = opB;
    assign rd_out                 = rd_in;
    assign RegWrite_out           = RegWrite_in;
    assign MemRead_out            = MemRead_in;
    assign MemWrite_out           = MemWrite_in;
    assign MemToReg_out           = MemToReg_in;

endmodule
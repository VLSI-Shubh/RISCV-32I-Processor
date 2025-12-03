// ======================================================
// RV32I 5-stage pipelined core
// Stages: IF -> ID -> EX -> MEM -> WB
// Uses existing stage modules and shared building blocks.
// ======================================================
module core_pip (
    input clk,
    input rst,
    output  [31:0] pc_debug
);

    // -------------------------
    // IF stage and IF/ID reg
    // -------------------------
    wire        stall_pc;
    wire        branch_taken_ex;
    wire [31:0] branch_target_ex;

    wire [31:0] pc_if;
    wire [31:0] instr_if;

    fetch u_fetch (
        .clk           (clk),
        .rst           (rst),
        .stall_pc      (stall_pc),
        .branch_taken  (branch_taken_ex),
        .branch_target (branch_target_ex),
        .pc_out        (pc_if),
        .instr_out     (instr_if)
    );

    assign pc_debug = pc_if;

    wire        stall_if_id;
    wire        flush_if_id;
    wire [31:0] pc_id;
    wire [31:0] instr_id;

    assign flush_if_id = branch_taken_ex;

    if_id_reg u_if_id_reg (
        .clk      (clk),
        .rst      (rst),
        .stall    (stall_if_id),
        .flush    (flush_if_id),
        .pc_in    (pc_if),
        .instr_in (instr_if),
        .pc_out   (pc_id),
        .instr_out(instr_id)
    );

    // -------------------------
    // ID stage and ID/EX reg
    // -------------------------
    // Writeback signals feeding the register file
    wire        RegWrite_wb;
    wire        MemToReg_wb;
    wire [31:0] alu_result_wb;
    wire [31:0] mem_read_data_wb;
    wire [4:0]  rd_wb;
    wire [31:0] wb_data;

     // Writeback mux (MemToReg)    
    //   in0 = ALU result
    //   in1 = load data
    mux #(.width(32)) u_wb_mux (
        .in0 (alu_result_wb),
        .in1 (mem_read_data_wb),
        .sel (MemToReg_wb),
        .out (wb_data)
    );

    wire [31:0] pc_id_dec;
    wire [31:0] rs1_data_id;
    wire [31:0] rs2_data_id;
    wire [31:0] imm_id;
    wire [4:0]  rs1_id;
    wire [4:0]  rs2_id;
    wire [4:0]  rd_id;
    wire [2:0]  funct3_id;
    wire        funct7_5_id;
    wire        RegWrite_id;
    wire        MemRead_id;
    wire        MemWrite_id;
    wire        MemToReg_id;
    wire        ALUSrc_id;
    wire        Branch_id;
    wire [1:0]  ALUOp_id;

    decode u_decode (
        .clk         (clk),
        .rst         (rst),
        .pc_in       (pc_id),
        .instr_in    (instr_id),
        .RegWrite_wb (RegWrite_wb),
        .rd_wb       (rd_wb),
        .wb_data_wb  (wb_data),
        .pc_out      (pc_id_dec),
        .rs1_data_out(rs1_data_id),
        .rs2_data_out(rs2_data_id),
        .imm_out     (imm_id),
        .rs1_out     (rs1_id),
        .rs2_out     (rs2_id),
        .rd_out      (rd_id),
        .funct3_out  (funct3_id),
        .funct7_5_out(funct7_5_id),
        .RegWrite_out(RegWrite_id),
        .MemRead_out (MemRead_id),
        .MemWrite_out(MemWrite_id),
        .MemToReg_out(MemToReg_id),
        .ALUSrc_out  (ALUSrc_id),
        .Branch_out  (Branch_id),
        .ALUOp_out   (ALUOp_id)
    );

    // ID/EX pipeline register
    wire        flush_id_ex_hazard;
    wire        flush_id_ex;
    wire [31:0] pc_ex;
    wire [31:0] rs1_data_ex;
    wire [31:0] rs2_data_ex;
    wire [31:0] imm_ex;
    wire [4:0]  rs1_ex;
    wire [4:0]  rs2_ex;
    wire [4:0]  rd_ex;
    wire [2:0]  funct3_ex;
    wire        funct7_5_ex;
    wire        RegWrite_ex;
    wire        MemRead_ex;
    wire        MemWrite_ex;
    wire        MemToReg_ex;
    wire        ALUSrc_ex;
    wire        Branch_ex;
    wire [1:0]  ALUOp_ex;

    assign flush_id_ex = flush_id_ex_hazard | branch_taken_ex;

    id_ex_reg u_id_ex_reg (
        .clk          (clk),
        .rst          (rst),
        .flush        (flush_id_ex),
        .pc_in        (pc_id_dec),
        .rs1_data_in  (rs1_data_id),
        .rs2_data_in  (rs2_data_id),
        .imm_in       (imm_id),
        .rs1_in       (rs1_id),
        .rs2_in       (rs2_id),
        .rd_in        (rd_id),
        .funct3_in    (funct3_id),
        .funct7_5_in  (funct7_5_id),
        .RegWrite_in  (RegWrite_id),
        .MemRead_in   (MemRead_id),
        .MemWrite_in  (MemWrite_id),
        .MemToReg_in  (MemToReg_id),
        .ALUSrc_in    (ALUSrc_id),
        .Branch_in    (Branch_id),
        .ALUOp_in     (ALUOp_id),
        .pc_out       (pc_ex),
        .rs1_data_out (rs1_data_ex),
        .rs2_data_out (rs2_data_ex),
        .imm_out      (imm_ex),
        .rs1_out      (rs1_ex),
        .rs2_out      (rs2_ex),
        .rd_out       (rd_ex),
        .funct3_out   (funct3_ex),
        .funct7_5_out (funct7_5_ex),
        .RegWrite_out (RegWrite_ex),
        .MemRead_out  (MemRead_ex),
        .MemWrite_out (MemWrite_ex),
        .MemToReg_out (MemToReg_ex),
        .ALUSrc_out   (ALUSrc_ex),
        .Branch_out   (Branch_ex),
        .ALUOp_out    (ALUOp_ex)
    );

    // -------------------------
    // Hazard detection (ID side)
    // -------------------------
    wire [4:0] if_id_rs1 = instr_id[19:15];
    wire [4:0] if_id_rs2 = instr_id[24:20];

    hazard_unit u_hazard (
        .id_ex_memRead (MemRead_ex),
        .id_ex_rd      (rd_ex),
        .if_id_rs1     (if_id_rs1),
        .if_id_rs2     (if_id_rs2),
        .stall_pc      (stall_pc),
        .stall_if_id   (stall_if_id),
        .flush_id_ex   (flush_id_ex_hazard)
    );

    // -------------------------
    // Forwarding unit (EX side)
    // -------------------------
    wire [1:0] forwardA;
    wire [1:0] forwardB;

    // EX/MEM and MEM/WB signals used for forwarding
    wire        RegWrite_ex_mem;
    wire [4:0]  rd_ex_mem;

    forwarding_unit u_forwarding (
        .id_ex_rs1       (rs1_ex),
        .id_ex_rs2       (rs2_ex),
        .ex_mem_rd       (rd_ex_mem),
        .ex_mem_RegWrite (RegWrite_ex_mem),
        .mem_wb_rd       (rd_wb),
        .mem_wb_RegWrite (RegWrite_wb),
        .forwardA        (forwardA),
        .forwardB        (forwardB)
    );

    // -------------------------
    // EX stage and EX/MEM reg
    // -------------------------
    wire [31:0] alu_result_ex;
    wire [31:0] rs2_data_fwd_ex;
    wire [4:0]  rd_ex_out;
    wire        RegWrite_ex_out;
    wire        MemRead_ex_out;
    wire        MemWrite_ex_out;
    wire        MemToReg_ex_out;

    wire [31:0] alu_result_ex_mem;
    wire [31:0] rs2_data_ex_mem;
    wire        MemRead_ex_mem;
    wire        MemWrite_ex_mem;
    wire        MemToReg_ex_mem;

    execute u_execute (
        .pc_in                 (pc_ex),
        .rs1_data_in           (rs1_data_ex),
        .rs2_data_in           (rs2_data_ex),
        .imm_in                (imm_ex),
        .rs1_in                (rs1_ex),
        .rs2_in                (rs2_ex),
        .rd_in                 (rd_ex),
        .funct3_in             (funct3_ex),
        .funct7_5_in           (funct7_5_ex),
        .RegWrite_in           (RegWrite_ex),
        .MemRead_in            (MemRead_ex),
        .MemWrite_in           (MemWrite_ex),
        .MemToReg_in           (MemToReg_ex),
        .ALUSrc_in             (ALUSrc_ex),
        .Branch_in             (Branch_ex),
        .ALUOp_in              (ALUOp_ex),
        .forwardA              (forwardA),
        .forwardB              (forwardB),
        .ex_mem_alu_result     (alu_result_ex_mem),
        .wb_data               (wb_data),
        .alu_result_out        (alu_result_ex),
        .rs2_data_forwarded_out(rs2_data_fwd_ex),
        .rd_out                (rd_ex_out),
        .RegWrite_out          (RegWrite_ex_out),
        .MemRead_out           (MemRead_ex_out),
        .MemWrite_out          (MemWrite_ex_out),
        .MemToReg_out          (MemToReg_ex_out),
        .branch_taken_out      (branch_taken_ex),
        .branch_target_out     (branch_target_ex)
    );

    ex_mem_reg u_ex_mem_reg (
        .clk            (clk),
        .rst            (rst),
        .RegWrite_in    (RegWrite_ex_out),
        .MemRead_in     (MemRead_ex_out),
        .MemWrite_in    (MemWrite_ex_out),
        .MemToReg_in    (MemToReg_ex_out),
        .alu_result_in  (alu_result_ex),
        .rs2_data_in    (rs2_data_fwd_ex),
        .rd_in          (rd_ex_out),
        .RegWrite_out   (RegWrite_ex_mem),
        .MemRead_out    (MemRead_ex_mem),
        .MemWrite_out   (MemWrite_ex_mem),
        .MemToReg_out   (MemToReg_ex_mem),
        .alu_result_out (alu_result_ex_mem),
        .rs2_data_out   (rs2_data_ex_mem),
        .rd_out         (rd_ex_mem)
    );

    // -------------------------
    // MEM stage and MEM/WB reg
    // -------------------------
    wire [31:0] mem_read_data_mem;

    memory u_memory (
        .clk           (clk),
        .rst           (rst),
        .MemRead       (MemRead_ex_mem),
        .MemWrite      (MemWrite_ex_mem),
        .addr_in       (alu_result_ex_mem),
        .write_data_in (rs2_data_ex_mem),
        .read_data_out (mem_read_data_mem)
    );

    mem_wb_reg u_mem_wb_reg (
        .clk              (clk),
        .rst              (rst),
        .RegWrite_in      (RegWrite_ex_mem),
        .MemToReg_in      (MemToReg_ex_mem),
        .alu_result_in    (alu_result_ex_mem),
        .mem_read_data_in (mem_read_data_mem),
        .rd_in            (rd_ex_mem),
        .RegWrite_out     (RegWrite_wb),
        .MemToReg_out     (MemToReg_wb),
        .alu_result_out   (alu_result_wb),
        .mem_read_data_out(mem_read_data_wb),
        .rd_out           (rd_wb)
    );

endmodule

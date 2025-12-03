// ======================================================
// Decode Stage (ID)
// - Uses control, reg_file, imm
// - Decodes instruction fields, generates control signals,
//   reads register operands, and forms the immediate.
//   Outputs feed the ID/EX pipeline register.
// ======================================================
module decode (
    input         clk,
    input         rst,

    // From IF/ID pipeline register
    input  [31:0] pc_in,
    input  [31:0] instr_in,

    // From WB stage (for register file write-back)
    input         RegWrite_wb,
    input  [4:0]  rd_wb,
    input  [31:0] wb_data_wb,

    // Outputs to ID/EX pipeline register
    output [31:0] pc_out,
    output [31:0] rs1_data_out,
    output [31:0] rs2_data_out,
    output [31:0] imm_out,
    output [4:0]  rs1_out,
    output [4:0]  rs2_out,
    output [4:0]  rd_out,
    output [2:0]  funct3_out,
    output        funct7_5_out,
    output        RegWrite_out,
    output        MemRead_out,
    output        MemWrite_out,
    output        MemToReg_out,
    output        ALUSrc_out,
    output        Branch_out,
    output [1:0]  ALUOp_out
);

    // --------------------------------------------------
    // 1) Instruction field extraction
    // --------------------------------------------------
    wire [6:0] opcode   = instr_in[6:0];
    wire [4:0] rd       = instr_in[11:7];
    wire [2:0] funct3   = instr_in[14:12];
    wire [4:0] rs1      = instr_in[19:15];
    wire [4:0] rs2      = instr_in[24:20];
    wire       funct7_5 = instr_in[30];

    // --------------------------------------------------
    // 2) Main control unit (control.v)
    // --------------------------------------------------
    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire MemToReg;
    wire ALUSrc;
    wire Branch;
    wire [1:0] ALUOp;

    control u_control (
        .opcode   (opcode),
        .RegWrite (RegWrite),
        .MemRead  (MemRead),
        .MemWrite (MemWrite),
        .MemToReg (MemToReg),
        .ALUSrc   (ALUSrc),
        .Branch   (Branch),
        .ALUOp    (ALUOp)
    );

    // --------------------------------------------------
    // 3) Register file (reg_file.v)
    // --------------------------------------------------
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    reg_file u_reg_file (
        .clk        (clk),
        .rst        (rst),
        .RegWrite   (RegWrite_wb),
        .read_reg1  (rs1),
        .read_reg2  (rs2),
        .write_reg  (rd_wb),
        .write_data (wb_data_wb),
        .read_data1 (rs1_data),
        .read_data2 (rs2_data)
    );

    // --------------------------------------------------
    // 4) Immediate generator (imm.v)
    // --------------------------------------------------
    wire [31:0] imm;

    imm u_imm (
        .instr   (instr_in),
        .opcode  (opcode),
        .imm_out (imm)
    );

    // --------------------------------------------------
    // 5) Drive outputs to ID/EX
    // --------------------------------------------------
    assign pc_out        = pc_in;

    assign rs1_data_out  = rs1_data;
    assign rs2_data_out  = rs2_data;
    assign imm_out       = imm;

    assign rs1_out       = rs1;
    assign rs2_out       = rs2;
    assign rd_out        = rd;

    assign funct3_out    = funct3;
    assign funct7_5_out  = funct7_5;

    assign RegWrite_out  = RegWrite;
    assign MemRead_out   = MemRead;
    assign MemWrite_out  = MemWrite;
    assign MemToReg_out  = MemToReg;
    assign ALUSrc_out    = ALUSrc;
    assign Branch_out    = Branch;
    assign ALUOp_out     = ALUOp;

endmodule
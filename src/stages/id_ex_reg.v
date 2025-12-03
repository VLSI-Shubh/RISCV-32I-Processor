// ======================================================
// ID/EX Pipeline Register
// - Holds outputs of Decode stage for use in Execute.
// - Supports flush, which zeroes control signals and
//   effectively inserts a bubble into EX.
// ======================================================
module id_ex_reg (
    input         clk,
    input         rst,

    // Control from hazard/branch logic
    input         flush,          // 1 = bubble: zero control signals

    // Inputs from Decode stage
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

    // Outputs to Execute stage
    output reg [31:0] pc_out,
    output reg [31:0] rs1_data_out,
    output reg [31:0] rs2_data_out,
    output reg [31:0] imm_out,
    output reg [4:0]  rs1_out,
    output reg [4:0]  rs2_out,
    output reg [4:0]  rd_out,
    output reg [2:0]  funct3_out,
    output reg        funct7_5_out,

    output reg        RegWrite_out,
    output reg        MemRead_out,
    output reg        MemWrite_out,
    output reg        MemToReg_out,
    output reg        ALUSrc_out,
    output reg        Branch_out,
    output reg [1:0]  ALUOp_out
);

    always @(posedge clk) begin
        if (rst) begin
            pc_out        <= 32'b0;
            rs1_data_out  <= 32'b0;
            rs2_data_out  <= 32'b0;
            imm_out       <= 32'b0;
            rs1_out       <= 5'b0;
            rs2_out       <= 5'b0;
            rd_out        <= 5'b0;
            funct3_out    <= 3'b0;
            funct7_5_out  <= 1'b0;

            RegWrite_out  <= 1'b0;
            MemRead_out   <= 1'b0;
            MemWrite_out  <= 1'b0;
            MemToReg_out  <= 1'b0;
            ALUSrc_out    <= 1'b0;
            Branch_out    <= 1'b0;
            ALUOp_out     <= 2'b0;

        end else if (flush) begin
            // Data fields can pass through; control is zeroed to form a bubble.
            pc_out        <= pc_in;
            rs1_data_out  <= rs1_data_in;
            rs2_data_out  <= rs2_data_in;
            imm_out       <= imm_in;
            rs1_out       <= rs1_in;
            rs2_out       <= rs2_in;
            rd_out        <= rd_in;
            funct3_out    <= funct3_in;
            funct7_5_out  <= funct7_5_in;

            RegWrite_out  <= 1'b0;
            MemRead_out   <= 1'b0;
            MemWrite_out  <= 1'b0;
            MemToReg_out  <= 1'b0;
            ALUSrc_out    <= 1'b0;
            Branch_out    <= 1'b0;
            ALUOp_out     <= 2'b0;

        end else begin
            pc_out        <= pc_in;
            rs1_data_out  <= rs1_data_in;
            rs2_data_out  <= rs2_data_in;
            imm_out       <= imm_in;
            rs1_out       <= rs1_in;
            rs2_out       <= rs2_in;
            rd_out        <= rd_in;
            funct3_out    <= funct3_in;
            funct7_5_out  <= funct7_5_in;

            RegWrite_out  <= RegWrite_in;
            MemRead_out   <= MemRead_in;
            MemWrite_out  <= MemWrite_in;
            MemToReg_out  <= MemToReg_in;
            ALUSrc_out    <= ALUSrc_in;
            Branch_out    <= Branch_in;
            ALUOp_out     <= ALUOp_in;
        end
    end

endmodule
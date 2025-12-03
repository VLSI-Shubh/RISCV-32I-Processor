// ======================================================
// EX/MEM Pipeline Register
// - Holds outputs of Execute stage for use in Memory.
//   No flush/stall here; once in EX, each instruction
//   flows through to MEM.
// ======================================================
module ex_mem_reg (
    input         clk,
    input         rst,

    // Inputs from Execute stage
    input         RegWrite_in,
    input         MemRead_in,
    input         MemWrite_in,
    input         MemToReg_in,
    input  [31:0] alu_result_in,
    input  [31:0] rs2_data_in,      // store data (after forwarding in EX)
    input  [4:0]  rd_in,

    // Outputs to Memory stage and forwarding logic
    output reg        RegWrite_out,
    output reg        MemRead_out,
    output reg        MemWrite_out,
    output reg        MemToReg_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] rs2_data_out,
    output reg [4:0]  rd_out
);

    always @(posedge clk) begin
        if (rst) begin
            RegWrite_out   <= 1'b0;
            MemRead_out    <= 1'b0;
            MemWrite_out   <= 1'b0;
            MemToReg_out   <= 1'b0;
            alu_result_out <= 32'b0;
            rs2_data_out   <= 32'b0;
            rd_out         <= 5'b0;
        end else begin
            RegWrite_out   <= RegWrite_in;
            MemRead_out    <= MemRead_in;
            MemWrite_out   <= MemWrite_in;
            MemToReg_out   <= MemToReg_in;
            alu_result_out <= alu_result_in;
            rs2_data_out   <= rs2_data_in;
            rd_out         <= rd_in;
        end
    end

endmodule
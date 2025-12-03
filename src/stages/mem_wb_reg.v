// ======================================================
// MEM/WB Pipeline Register
// - Holds outputs of Memory stage for Writeback.
//   Provides the ALU result, load data, and control
//   signals needed to drive the WB mux and regfile.
// ======================================================
module mem_wb_reg (
    input         clk,
    input         rst,

    // Inputs from Memory stage
    input         RegWrite_in,
    input         MemToReg_in,
    input  [31:0] alu_result_in,
    input  [31:0] mem_read_data_in,
    input  [4:0]  rd_in,

    // Outputs to Writeback (and regfile in Decode stage)
    output reg        RegWrite_out,
    output reg        MemToReg_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] mem_read_data_out,
    output reg [4:0]  rd_out
);

    always @(posedge clk) begin
        if (rst) begin
            RegWrite_out      <= 1'b0;
            MemToReg_out      <= 1'b0;
            alu_result_out    <= 32'b0;
            mem_read_data_out <= 32'b0;
            rd_out            <= 5'b0;
        end else begin
            RegWrite_out      <= RegWrite_in;
            MemToReg_out      <= MemToReg_in;
            alu_result_out    <= alu_result_in;
            mem_read_data_out <= mem_read_data_in;
            rd_out            <= rd_in;
        end
    end

endmodule

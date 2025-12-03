// ======================================================
// IF/ID Pipeline Register
// - Holds PC and instruction between Fetch and Decode
// - Supports stall (hold) and flush (clear instruction).
//   When flushed, instr_out is zero, which decodes to
//   a bubble because control.v treats unknown opcode
//   as all control signals deasserted.
// ======================================================
module if_id_reg (
    input         clk,
    input         rst,

    // Control signals
    input         stall,      // 1 = hold outputs
    input         flush,      // 1 = clear instruction

    // Inputs from Fetch stage
    input  [31:0] pc_in,
    input  [31:0] instr_in,

    // Outputs to Decode stage
    output reg [31:0] pc_out,
    output reg [31:0] instr_out
);

    always @(posedge clk) begin
        if (rst) begin
            pc_out    <= 32'b0;
            instr_out <= 32'b0;
        end else if (flush) begin
            pc_out    <= 32'b0;
            instr_out <= 32'b0;
        end else if (!stall) begin
            pc_out    <= pc_in;
            instr_out <= instr_in;
        end
        // If stall = 1 and flush = 0: hold previous values.
    end

endmodule
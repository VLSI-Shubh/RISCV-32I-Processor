// ======================================================
// Memory Stage (MEM)
// - Same behavior as the data memory used in the
//   single-cycle core.
// - 256 x 32-bit memory, word-addressed via addr_in[9:2].
// ======================================================
module memory (
    input         clk,
    input         rst,

    input         MemRead,
    input         MemWrite,
    input  [31:0] addr_in,         // ALU result from EX/MEM (byte address)
    input  [31:0] write_data_in,   // rs2_data from EX/MEM (store data)

    output reg [31:0] read_data_out
);

    // 256 x 32-bit data memory
    reg [31:0] data_mem [0:255];
    integer i;

    // Word address derived from byte-aligned address [9:2]
    wire [7:0] word_addr = addr_in[9:2];

    // --------------------------------------------------
    // Synchronous write and reset
    // --------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 256; i = i + 1) begin
                data_mem[i] <= 32'b0;
            end
        end else begin
            if (MemWrite) begin
                data_mem[word_addr] <= write_data_in;
            end
        end
    end

    // --------------------------------------------------
    // Combinational read
    // - When MemRead = 1, output selected word
    // - When MemRead = 0, output 0
    // --------------------------------------------------
    always @(*) begin
        if (MemRead) begin
            read_data_out = data_mem[word_addr];
        end else begin
            read_data_out = 32'b0;
        end
    end

endmodule
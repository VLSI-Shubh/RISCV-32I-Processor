module reg_file(
    input         clk,
    input         rst,
    input         RegWrite,
    input  [4:0]  Rs1,
    input  [4:0]  Rs2,
    input  [4:0]  Rd,
    input  [31:0] Write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
);

    // 32 registers, each 32-bit
    reg [31:0] Registers [31:0];

    integer i;

    // Optional: initial values (OK for FPGA, not for ASIC)
    initial begin
        Registers[0]  = 32'd0;
        Registers[1]  = 32'd3;
        Registers[2]  = 32'd2;
        Registers[3]  = 32'd12;
        Registers[4]  = 32'd20;
        Registers[5]  = 32'd3;
        Registers[6]  = 32'd44;
        Registers[7]  = 32'd4;
        Registers[8]  = 32'd2;
        Registers[9]  = 32'd1;
        Registers[10] = 32'd23;
        Registers[11] = 32'd4;
        Registers[12] = 32'd90;
        Registers[13] = 32'd10;
        Registers[14] = 32'd20;
        Registers[15] = 32'd30;
        Registers[16] = 32'd40;
        Registers[17] = 32'd50;
        Registers[18] = 32'd60;
        Registers[19] = 32'd70;
        Registers[20] = 32'd80;
        Registers[21] = 32'd80;
        Registers[22] = 32'd90;
        Registers[23] = 32'd70;
        Registers[24] = 32'd60;
        Registers[25] = 32'd65;
        Registers[26] = 32'd4;
        Registers[27] = 32'd32;
        Registers[28] = 32'd12;
        Registers[29] = 32'd34;
        Registers[30] = 32'd5;
        Registers[31] = 32'd10;
    end

    // Synchronous reset + write
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                Registers[i] <= 32'b0;
        end
        else if (RegWrite && (Rd != 5'd0)) begin
            // x0 is read-only zero in RISC-V: ignore writes to x0
            Registers[Rd] <= Write_data;
        end
    end

    // Combinational read ports
    assign read_data1 = (Rs1 == 5'd0) ? 32'b0 : Registers[Rs1];
    assign read_data2 = (Rs2 == 5'd0) ? 32'b0 : Registers[Rs2];

endmodule

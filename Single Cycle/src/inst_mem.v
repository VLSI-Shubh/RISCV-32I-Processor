module inst_mem(
    input  [31:0] read_address,   // PC (byte address)
    output [31:0] instruction_out
);
    reg [31:0] I_Mem [0:255];     // 256 instructions

    wire [7:0] word_addr = read_address[9:2];

    assign instruction_out = I_Mem[word_addr];

    initial begin
        $readmemh("instruction.mem", I_Mem);
    end
endmodule

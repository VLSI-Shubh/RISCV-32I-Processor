module core_sc (
    input clk,
    input rst
);

    // PC and instruction path
    wire [31:0] pc_curr;
    wire [31:0] pc_next;
    wire [31:0] pc_plus4;
    wire [31:0] pc_branch;
    wire [31:0] instr;

    // Register file
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    // Immediate
    wire [31:0] imm_out;

    // Control signals
    wire        RegWrite;
    wire        MemRead;
    wire        MemWrite;
    wire        MemToReg;
    wire        ALUSrc;
    wire        Branch;
    wire [1:0]  ALUOp;

    // ALU and ALU control
    wire [3:0]  alu_ctrl;
    wire [31:0] alu_b_in;
    wire [31:0] alu_out;
    wire        zero;

    // Data memory and writeback
    wire [31:0] mem_read_data;
    wire [31:0] wb_data;

    // ------------------------
    // Program counter
    // ------------------------

    pc u_pc (
        .pc_in(pc_next),
        .clk(clk),
        .rst(rst),
        .pc_out(pc_curr)
    );

    // PC + 4
    adder #(.WIDTH(32)) u_pc_plus4 (
        .a(pc_curr),
        .b(32'd4),
        .sum(pc_plus4)
    );

    // Branch target = PC + imm
    adder #(.WIDTH(32)) u_branch_adder (
        .a(pc_curr),
        .b(imm_out),
        .sum(pc_branch)
    );

    // Branch decision
    wire take_branch = Branch & zero;

    // Next PC MUX: sequential or branch target
    mux #(.width(32)) u_pc_mux (
        .in0(pc_plus4),
        .in1(pc_branch),
        .sel(take_branch),
        .out(pc_next)
    );

    // ------------------------
    // Instruction fetch
    // ------------------------

    inst_mem u_imem (
        .read_address(pc_curr),
        .instruction_out(instr)
    );

    // ------------------------
    // Decode fields
    // ------------------------

    wire [6:0] opcode   = instr[6:0];
    wire [4:0] rd       = instr[11:7];
    wire [2:0] funct3   = instr[14:12];
    wire [4:0] rs1      = instr[19:15];
    wire [4:0] rs2      = instr[24:20];
    wire       funct7_5 = instr[30];

    // ------------------------
    // Register file
    // ------------------------

    reg_file u_regfile (
        .clk(clk),
        .rst(rst),
        .RegWrite(RegWrite),
        .Rs1(rs1),
        .Rs2(rs2),
        .Rd(rd),
        .Write_data(wb_data),
        .read_data1(rs1_data),
        .read_data2(rs2_data)
    );

    // ------------------------
    // Main control
    // ------------------------

    control u_ctrl (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    // ------------------------
    // Immediate generator
    // ------------------------

    imm u_imm (
        .instruction(instr),
        .imm_out(imm_out)
    );

    // ------------------------
    // ALU control
    // ------------------------

    alu_control u_alu_ctrl (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .ALUCtrl(alu_ctrl)
    );

    // ------------------------
    // ALU input B MUX (reg or imm)
    // ------------------------

    mux #(.width(32)) u_alusrc_mux (
        .in0(rs2_data),
        .in1(imm_out),
        .sel(ALUSrc),
        .out(alu_b_in)
    );

    // ------------------------
    // ALU
    // ------------------------

    alu u_alu (
        .A(rs1_data),
        .B(alu_b_in),
        .alu_ctrl(alu_ctrl),
        .alu_out(alu_out),
        .zero(zero)
    );

    // ------------------------
    // Simple data memory (word addressed like instruction memory)
    // ------------------------

    reg [31:0] data_mem [0:255];
    wire [7:0] data_word_addr = alu_out[9:2];

    // Combinational read
    assign mem_read_data = data_mem[data_word_addr];

    // Write on store
    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 256; i = i + 1)
                data_mem[i] <= 32'b0;
        end else if (MemWrite) begin
            data_mem[data_word_addr] <= rs2_data;
        end
    end

    // ------------------------
    // Writeback MUX: ALU result or load data
    // ------------------------

    mux #(.width(32)) u_wb_mux (
        .in0(alu_out),
        .in1(mem_read_data),
        .sel(MemToReg),
        .out(wb_data)
    );

endmodule

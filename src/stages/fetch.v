// ======================================================
// Fetch Stage (IF)
// - Uses pc, inst_mem, adder, mux
// - Holds the program counter, computes PC + 4,
//   selects between sequential and branch target,
//   and supports PC stalling.
// ======================================================
module fetch (
    input         clk,
    input         rst,

    // From hazard detection unit
    input         stall_pc,        // 1 = hold PC, 0 = update PC

    // From EX stage branch logic (branch_unit + PC+imm in EX)
    input         branch_taken,    // 1 = branch taken
    input  [31:0] branch_target,   // target PC when branch is taken

    // Outputs to IF/ID pipeline register
    output [31:0] pc_out,          // current PC value
    output [31:0] instr_out        // instruction fetched from inst_mem
);

    // Current PC
    wire [31:0] pc_curr;

    // PC + 4
    wire [31:0] pc_plus4;

    // Next PC after branch decision, before stall
    wire [31:0] pc_next_branch;

    // Final next PC after stall logic
    wire [31:0] pc_next;

    // --------------------------------------------------
    // PC + 4 calculation using the shared adder block
    // --------------------------------------------------
    adder #(.WIDTH(32)) u_pc_plus4 (
        .a   (pc_curr),
        .b   (32'd4),
        .sum (pc_plus4)
    );

    // --------------------------------------------------
    // Mux 1: branch vs sequential (pc_plus4)
    //   sel = branch_taken
    //   in0 = pc_plus4       (normal next PC)
    //   in1 = branch_target  (branch target PC)
    // --------------------------------------------------
    mux #(.width(32)) u_branch_mux (
        .in0 (pc_plus4),
        .in1 (branch_target),
        .sel (branch_taken),
        .out (pc_next_branch)
    );

    // --------------------------------------------------
    // Mux 2: stall vs update
    //   sel = stall_pc
    //   in0 = pc_next_branch   (normal operation)
    //   in1 = pc_curr          (hold current PC when stalling)
    // --------------------------------------------------
    mux #(.width(32)) u_stall_mux (
        .in0 (pc_next_branch),
        .in1 (pc_curr),
        .sel (stall_pc),
        .out (pc_next)
    );

    // --------------------------------------------------
    // PC register instance
    // --------------------------------------------------
    pc u_pc (
        .clk   (clk),
        .rst   (rst),
        .pc_in (pc_next),
        .pc_out(pc_curr)
    );

    // --------------------------------------------------
    // Instruction memory instance (byte-addressed, word-aligned)
    // --------------------------------------------------
    wire [31:0] instr;

    inst_mem u_inst_mem (
        .read_address   (pc_curr),
        .instruction_out(instr)
    );

    // --------------------------------------------------
    // Outputs to IF/ID register
    // --------------------------------------------------
    assign pc_out    = pc_curr;
    assign instr_out = instr;

endmodule

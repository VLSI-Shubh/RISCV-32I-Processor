// ======================================================
// Forwarding Unit
// - Resolves data hazards by selecting forwarded values
//   for ALU operands in the EX stage.
// - Priority:
//     * EX/MEM (most recent) has priority over MEM/WB.
// - Does not compute ALU results; only generates mux
//   select signals used by the Execute stage.
// ======================================================
module forwarding_unit (
    input  [4:0] id_ex_rs1,          // rs1 of instruction in EX (ID/EX)
    input  [4:0] id_ex_rs2,          // rs2 of instruction in EX (ID/EX)

    input  [4:0] ex_mem_rd,          // rd of instruction in MEM (EX/MEM)
    input        ex_mem_RegWrite,    // RegWrite of EX/MEM

    input  [4:0] mem_wb_rd,          // rd of instruction in WB (MEM/WB)
    input        mem_wb_RegWrite,    // RegWrite of MEM/WB

    output reg [1:0] forwardA,       // select for ALU operand A
    output reg [1:0] forwardB        // select for ALU operand B
);

    always @(*) begin
        // Defaults: no forwarding
        forwardA = 2'b00;
        forwardB = 2'b00;

        // EX hazard: forward from EX/MEM if match on rs1
        if (ex_mem_RegWrite &&
            (ex_mem_rd != 5'd0) &&
            (ex_mem_rd == id_ex_rs1)) begin
            forwardA = 2'b10;
        end

        // EX hazard: forward from EX/MEM if match on rs2
        if (ex_mem_RegWrite &&
            (ex_mem_rd != 5'd0) &&
            (ex_mem_rd == id_ex_rs2)) begin
            forwardB = 2'b10;
        end

        // MEM hazard: forward from MEM/WB if match on rs1
        // and EX/MEM did not already claim it.
        if (mem_wb_RegWrite &&
            (mem_wb_rd != 5'd0) &&
            (mem_wb_rd == id_ex_rs1) &&
            !(ex_mem_RegWrite &&
              (ex_mem_rd != 5'd0) &&
              (ex_mem_rd == id_ex_rs1))) begin
            forwardA = 2'b01;
        end

        // MEM hazard: forward from MEM/WB if match on rs2
        // and EX/MEM did not already claim it.
        if (mem_wb_RegWrite &&
            (mem_wb_rd != 5'd0) &&
            (mem_wb_rd == id_ex_rs2) &&
            !(ex_mem_RegWrite &&
              (ex_mem_rd != 5'd0) &&
              (ex_mem_rd == id_ex_rs2))) begin
            forwardB = 2'b01;
        end
    end

endmodule
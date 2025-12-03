// ======================================================
// Hazard Detection Unit
// - Detects load-use hazards between:
//     * ID/EX stage (load instruction)
//     * IF/ID stage (instruction that uses the loaded reg)
// - On hazard:
//     * stall_pc   = 1 (hold PC)
//     * stall_if_id = 1 (hold IF/ID)
//     * flush_id_ex = 1 (insert bubble into EX)
// ======================================================
module hazard_unit (
    input        id_ex_memRead,   // MemRead from ID/EX
    input  [4:0] id_ex_rd,        // destination reg of ID/EX instruction
    input  [4:0] if_id_rs1,       // source register rs1 in IF/ID
    input  [4:0] if_id_rs2,       // source register rs2 in IF/ID

    output       stall_pc,
    output       stall_if_id,
    output       flush_id_ex
);

    wire load_use_hazard;

    // --------------------------------------------------
    // Load-use hazard condition:
    //   - ID/EX is a load (id_ex_memRead = 1)
    //   - Destination register of that load (id_ex_rd)
    //     is used as rs1 or rs2 in IF/ID.
    // --------------------------------------------------
    assign load_use_hazard =
        id_ex_memRead &&
        (id_ex_rd != 5'd0) &&
        ((id_ex_rd == if_id_rs1) ||
         (id_ex_rd == if_id_rs2));

    // --------------------------------------------------
    // Outputs
    // --------------------------------------------------
    assign stall_pc    = load_use_hazard;
    assign stall_if_id = load_use_hazard;
    assign flush_id_ex = load_use_hazard;

endmodule
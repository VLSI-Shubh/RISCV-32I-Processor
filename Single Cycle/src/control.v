module control(
    input [6:0] opcode,          
    output reg RegWrite,         
    output reg MemRead,          
    output reg MemWrite,         
    output reg MemToReg,        
    output reg ALUSrc,                      
    output reg Branch,                        
    output reg [1:0] ALUOp       
);

    always @(*) begin
        case (opcode)
            7'b0110011:  // R-type 
            begin  {ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10};end
            7'b0010011:   // I-type
            begin {ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = {1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10};end
            7'b0000011:   // Load 
            begin {ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 2'b00};end
            7'b0100011:   // Store 
            begin {ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = {1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 2'b00};end
            7'b1100011:   // Branch 
            begin {ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 2'b01};end  
            7'b1101111:   // Jump 
            begin  {ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10};end
            7'b0110111:   // LUI
            begin {ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = {1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b11};end
            default: 
            begin {ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00};end  
        endcase
    end

endmodule
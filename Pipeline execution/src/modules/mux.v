module mux #(parameter width = 32)(
    input [width-1:0] in0, in1,
    input sel,
    output reg [width-1:0] out
);
    always @(*) begin
        out = (sel) ? in1 : in0;
    end
endmodule
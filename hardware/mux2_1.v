module mux2_1 (
    input [31:0] a,
    input [31:0] b,
    input sel,
    output [31:0] res
);

    assign res = sel ? a : b;

endmodule
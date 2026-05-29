module extensor(
    input [15:0] x,
    output [31:0] res
);

    assign res = {16'b0, x};

endmodule
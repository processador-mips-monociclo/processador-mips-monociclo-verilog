module somador_pc (
    input [31:0] pc,
    output [31:0] pc_mais_4
);

assign pc_mais_4 = pc + 32'd4;

endmodule
module pc (
    input wire clock,
    input [31:0] nextpc, //vem do somador_pc
    output reg [31:0] pc
);

//garante que o PC começa em zero
initial begin
    pc = 32'h00000000;
end

always @(posedge clock) begin
    pc <= nextpc;
end

endmodule
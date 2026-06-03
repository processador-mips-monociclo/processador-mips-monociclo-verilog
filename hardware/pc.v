module PC (
    input clock,
    input [31:0] nextPc, //vem do somador_pc
    output reg [31:0] pc
);

//garante que o PC começa em zero
initial begin
    PC = 32'h00000000;
end

always @(posedge clock) begin
    pc <= nextPc;
end

endmodule
module PC (
    input clock,
    input [31:0] nextPc, //vem do somador_pc
    output [31:0] pc
);

always @(posedge clock) begin
    pc <= nextPc;
end

endmodule
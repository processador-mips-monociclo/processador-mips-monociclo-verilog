module i_mem #(parameter SIZE = 256)(
    input [31:0] address,
    output [31:0] i_out
);

reg [31:0] rom  [0:SIZE - 1];

initial begin
    $readmemb("instruction.list.v", rom);
end

assign i_out = rom[address >> 2];   

endmodule
module d_mem #(parameter SIZE = 256) (
    input [31:0] address,
    input [31:0] writeData,
    input memWrite,
    input memRead,
    output [31:0] readData
);

reg [31:0] ram [0:SIZE-1];

always @(*) begin
        if (MemWrite) begin
            ram[Address >> 2] = WriteData;
        end
    end

assign ReadData = (MemRead) ? ram[Address >> 2] : 32'bz;

endmodule
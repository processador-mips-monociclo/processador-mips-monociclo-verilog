module regfile(
    input clock,
    input regWrite,
    input reset,
    input [4:0] readAddr1,
    input [4:0] readAddr2,
    input [4:0] writeAddr,
    input [31:0] writeData,
    output [31:0] readData1,
    output [31:0] readData2
);

reg [31:0] registers [0:31];
integer i;

always @(posedge clock) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'h00000000;
            end
        end else if (regWrite) begin
            if (writeAddr != 5'd0) begin
                registers[writeAddr] <= writeData;
            end
        end
    end


assign readData1 = (readAddr1 == 5'd0) ? 32'd0 : registers[readAddr1];
assign readData2 = (readAddr2 == 5'd0) ? 32'd0 : registers[readAddr2];

endmodule
module ctrl (
    input wire [5:0] Opcode,
    output reg [1:0] RegDst,
    output reg ALUSrc,
    output reg [1:0] MemtoReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg Bne,
    output reg Jump,
    output reg [3:0] ALUOp
);

    always @(*) begin
        RegDst   = 2'b00;
        ALUSrc   = 1'b0;
        MemtoReg = 2'b00;
        RegWrite = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        Branch   = 1'b0;
        Bne      = 1'b0;
        Jump     = 1'b0;
        ALUOp    = 4'b0000;

        case (Opcode)
            6'b000000: begin
                RegDst   = 2'b01;
                RegWrite = 1'b1;
                ALUOp    = 4'b0000;
            end

            6'b000010: begin
                Jump = 1'b1;
            end

            6'b000011: begin
                Jump     = 1'b1;
                RegWrite = 1'b1;
                RegDst   = 2'b10; 
                MemtoReg = 2'b10;
            end

            6'b000100: begin
                Branch = 1'b1;
                ALUOp  = 4'b0010;
            end

            6'b000101: begin
                Bne   = 1'b1;
                ALUOp = 4'b0010;
            end

            6'b001000: begin
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
                ALUOp    = 4'b0001; 
            end

            6'b001010: begin
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
                ALUOp    = 4'b0110; 
            end

            6'b001011: begin
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
                ALUOp    = 4'b0111; 
            end

            6'b001100: begin
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
                ALUOp    = 4'b0011;
            end

            6'b001101: begin
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
                ALUOp    = 4'b0100;
            end

    
            6'b001110: begin
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
                ALUOp    = 4'b0101; 
            end

            6'b001111: begin
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
                ALUOp    = 4'b1000; 
            end

    
            6'b100011: begin
                ALUSrc   = 1'b1;
                MemtoReg = 2'b01; 
                RegWrite = 1'b1;
                MemRead  = 1'b1;
                ALUOp    = 4'b0001; 
            end

            6'b101011: begin
                ALUSrc   = 1'b1;
                MemWrite = 1'b1;
                ALUOp    = 4'b0001; 
            end
        endcase
    end
endmodule
/*
    Alunos: Matheus Aroxa, Davyson farias, Lucas Carvalho
    AOC 2026.1
    Descrição: Este componente é referente a unidade de controle, responsavel por atualizar os sinais de controles utilizados
*/
module ctrl (
    input wire [5:0] Opcode, //opcode vindo da instrução
    output reg [1:0] RegDst, //sinal de controle para decidir o registrador de destino no multiplexador
    output reg ALUSrc, //determina se o segundo valor vem de um registrador ou de um valor imediato
    output reg [1:0] MemtoReg, //determina se o valor escrito no registrador vem da memoria ou de um registrador
    output reg RegWrite, //habilita a escrita no registrador
    output reg MemRead, //habilita a leitura no registrador
    output reg MemWrite,  //habilita a escrita na memoria
    output reg Branch,
    output reg Bne,
    output reg Jump,
    output reg [3:0] ALUOp //operação realizada na ULA
);

    always @(*) begin
        //inicializa os valores com zero (evita latches inferidos)
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
            // Instruções Tipo-R (ex: add, sub, and, or, slt)
            6'b000000: begin
                RegDst   = 2'b01; // Destino é o rd
                RegWrite = 1'b1;  // Habilita escrita
                ALUOp    = 4'b0000; // Define operação via funct
            end

            // J (Jump)
            6'b000010: begin
                Jump = 1'b1; // Desvio incondicional
            end

            // JAL (Jump and Link)
            6'b000011: begin
                Jump     = 1'b1; 
                RegWrite = 1'b1;
                RegDst   = 2'b10; // Salva endereço de retorno no registrador $ra (31)
                MemtoReg = 2'b10; // Seleciona PC+4 como dado para o registrador
            end

            // BEQ (Branch if Equal)
            6'b000100: begin
                Branch = 1'b1;    // Habilita desvio condicional
                ALUOp  = 4'b0010; // Subtração para verificar igualdade
            end

            // BNE (Branch if Not Equal)
            6'b000101: begin
                Bne   = 1'b1;     // Habilita desvio se diferente
                ALUOp = 4'b0010;  // Subtração para verificação
            end

            // ADDI (Add Immediate)
            6'b001000: begin
                ALUSrc   = 1'b1;  // Usa valor imediato da instrução
                RegWrite = 1'b1;
                ALUOp    = 4'b0001; // Soma
            end

            // SLTI (Set Less Than Immediate)
            6'b001010: begin
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
                ALUOp    = 4'b0110; // Comparação menor que
            end

            // SLTIU (Set Less Than Immediate Unsigned)
            6'b001011: begin
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
                ALUOp    = 4'b0111; // Comparação unsigned
            end

            // ANDI (And Immediate)
            6'b001100: begin
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
                ALUOp    = 4'b0011; // Operação AND
            end

            // ORI (Or Immediate)
            6'b001101: begin
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
                ALUOp    = 4'b0100; // Operação OR
            end

            // XORI (Exclusive Or Immediate)
            6'b001110: begin
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
                ALUOp    = 4'b0101; // Operação XOR
            end

            // LUI (Load Upper Immediate)
            6'b001111: begin
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
                ALUOp    = 4'b1000; // Shift left 16 bits
            end

            // LW (Load Word)
            6'b100011: begin
                ALUSrc   = 1'b1;    // Soma imediato ao base
                MemtoReg = 2'b01;   // Dado vem da memória
                RegWrite = 1'b1;
                MemRead  = 1'b1;    // Habilita leitura na memória
                ALUOp    = 4'b0001; // Adição (cálculo de endereço)
            end

            // SW (Store Word)
            6'b101011: begin
                ALUSrc   = 1'b1;    // Soma imediato ao base
                MemWrite = 1'b1;    // Habilita escrita na memória
                ALUOp    = 4'b0001; // Adição (cálculo de endereço)
            end
        endcase
    end
endmodule
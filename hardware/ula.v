/*
    Alunos: Matheus Aroxa, Davyson farias, Lucas Carvalho
    AOC 2026.1
    Descrição: Este componente é referente a ULA.
*/
module ula(
    input [31:0] in1, //dado vindo do primeiro registrador
    input [31:0] in2, //dado vindo do segundo registrador
    input [3:0] op, //4 bits que indicam a operação a ser realizada
    output reg [31:0] result, //saida de 32 bits com o resultado da operação
    output reg zero_flag //flag de controle, 1 quando o resultado é zero
);

always @(*) begin
    //inicializa os valores
result = 32'b0;
zero_flag = 1'b0;

case (op)
    4'b0000: result = in1 + in2; // Adição
    4'b0001: result = in1 - in2; // Subtração
    4'b0010: result = in1 & in2; // AND (E)
    4'b0011: result = in1 | in2;// OR (OU)
    4'b0100: result = in1 ^ in2; // XOR
    4'b0101: result = ~(in1 | in2); // Nor

    // Operadores Shift
    4'b0110: result = in2 << in1[4:0]; // shift left lógico (sll) / sllv (sll varável)
    4'b0111: result = in2 >> in1[4:0]; // srl / srlv (sem sinal)
    4'b1000: result = $signed(in2) >>> in1[4:0]; // sra / srav (com sinal)

    // Comparações
    4'b1001: result = ($signed(in1) < $signed(in2)) ? 32'd1 : 32'd0; // signed menor que
    4'b1010: result = (in1 < in2) ? 32'd1 : 32'd0; // unsigned menor que

    4'b1011: result = in2;
    4'b1100: result = in1;

    //OBS: Ainda sobraram alguns bits para fazer outras operações caso necessário
    default: result = 32'b0;
endcase

    if (result == 0) begin
        zero_flag = 1'b1;
    end else
        zero_flag = 1'b0;
    end

endmodule
/*
    Alunos: Matheus Aroxa, Davyson farias, Lucas Carvalho
    AOC 2026.1
    Descrição: Este componente é utilizado para instruções tipo I, onde o valor vindo da instrução possui 16 bits e precisa ser convertido para 32 bits 
*/
module extensor(
    input [15:0] x, //recebe 32 bits da instrução
    output [31:0] res //saida com 32 bits
);

    assign res = {16'b0, x}; //conversão de 16 para 32 bits

endmodule
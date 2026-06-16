/*
    Alunos: Matheus Aroxa, Davyson farias, Lucas Carvalho
    AOC 2026.1
    Descrição: Este componente é um multiplexador 2x1 generico que será utilizado para fazer a integração entre os componentes
*/

module mux2_1 (
    input [31:0] a,
    input [31:0] b,
    input sel,
    output [31:0] res
);

    assign res = sel ? a : b;

endmodule
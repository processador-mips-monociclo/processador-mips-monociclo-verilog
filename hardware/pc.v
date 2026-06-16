/*
    Alunos: Matheus Aroxa, Davyson farias, Lucas Carvalho
    AOC 2026.1
    Descrição: Este componente é referente ao Program Counter (PC), responsável por ler os endereços de instrução da memória e enviar para o decodificador.
*/
module pc (
    input wire clock, //entrada de clock
    input [31:0] nextpc, //vem do somador_pc, representa a proxima instrução a ser executada
    output reg [31:0] pc //instrução atual
);

//garante que o PC começa em zero
initial begin
    pc = 32'h00000000;
end

always @(posedge clock) begin
    pc <= nextpc; //atualiza a instrução a cada clock
end

endmodule
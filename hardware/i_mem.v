/*
    Alunos: Matheus Aroxa, Davyson farias, Lucas Carvalho
    AOC 2026.1
    Descrição: Este componente é referente ao instruction memory, responsável por decodificar as instruções
*/
module i_mem #(parameter SIZE = 256)( //tamanho parametrizavel
    input [31:0] address, //recebe o endereço da instrucao
    output [31:0] i_out //saida é a instrucao no endereco da entrada
);

reg [31:0] rom  [0:SIZE - 1]; //cria um array com o tamanho parametrizado, contendo instruções de 32 bits

initial begin
    $readmemb("instruction.list.v", rom); //carrega as instrução do arquivo na memoria
end

assign i_out = rom[address >> 2];   //saida é a instrucao no endereco da entrada (divide por 4 porque o mips é endereçado byte a byte)

endmodule
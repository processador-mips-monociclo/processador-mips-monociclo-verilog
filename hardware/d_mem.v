/*
    Alunos: Matheus Aroxa, Davyson farias, Lucas Carvalho
    AOC 2026.1
    Descrição: Este componente é referente a memoria de dados do processador
*/
module d_mem #(parameter SIZE = 256) ( //tamanho parametrizavel
    input [31:0] Address, //endereco na memoria
    input [31:0] WriteData, //dado a ser escrito
    input MemWrite, //sinal de controle para escrita na memoria
    input MemRead, //sinal de controle para leitura da memoria
    output [31:0] ReadData //dado lido da memoria
);

reg [31:0] ram [0:SIZE-1]; //array com tamanho parametrizado contendo dados de 32 bits

always @(*) begin
        if (MemWrite) begin //verifica se a escrita na memória está habilitada
            //escreve o valor na memoria
            ram[Address >> 2] = WriteData; //divide o endereço por 4 devido ao endereçamento byte a byte
        end
    end

//se a leitura está ativa retorna o valor da memoria
assign ReadData = (MemRead) ? ram[Address >> 2] : 32'bz;

endmodule
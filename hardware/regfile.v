/*
    Alunos: Matheus Aroxa, Davyson farias, Lucas Carvalho
    AOC 2026.1
    Descrição: Este componente se refere ao banco de registradores
*/
module regfile(
    input clock, //recebe o clock
    input regWrite, //sinal de controle para escrita no registrador (1 quando a instrução é do tipo R ou lw)
    input reset, //sobrescreve o valor de todos os registradores para zero
    input [4:0] readAddr1, //rs
    input [4:0] readAddr2, // rt
    input [4:0] writeAddr, // rd
    input [31:0] writeData, //dado a ser escrito no registrador
    output [31:0] readData1, //dado lido do registrador rs
    output [31:0] readData2 //dado lido do registrador rt
);

reg [31:0] registers [0:31]; //array com 32 registradores de 32 bits
integer i;

always @(posedge clock) begin
        if (reset) begin //se reset = 1, zera todos os registradores
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'h00000000;
            end
        end else if (regWrite) begin //se regWrite = 1, permite a escrita em algum registrador 
            if (writeAddr != 5'd0) begin //não permite escrever no registrador zero
                registers[writeAddr] <= writeData; //escreve no registrador
            end
        end
    end

//retorna zero se o registrador lido for $zero, se não retorna o valor no registrador
assign readData1 = (readAddr1 == 5'd0) ? 32'd0 : registers[readAddr1];
assign readData2 = (readAddr2 == 5'd0) ? 32'd0 : registers[readAddr2];

endmodule
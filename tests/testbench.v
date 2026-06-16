`timescale 1ns / 1ps

module testbench;

    // Entradas do Top-Level
    reg clk;
    reg reset;

    // Saídas do Top-Level
    wire [31:0] pc_out;
    wire [31:0] ula_out;
    wire [31:0] dmem_out;

    // Instanciação do núcleo MIPS (Top-level)
    top uut (
        .clk(clk),
        .reset(reset),
        .pc_out(pc_out),
        .ula_out(ula_out),
        .dmem_out(dmem_out)
    );

    // Geração do Clock: inverte o sinal a cada 5ns (Período de 10ns = 100MHz)
    always #5 clk = ~clk;

    initial begin
        // Configuração do arquivo de saída para o GTKWave
        $dumpfile("tests/out/top_tb.vcd");
        $dumpvars(0, testbench);

        // Inicialização dos sinais
        clk = 0;
        reset = 1; // Ativa o reset no início (supondo reset ativo em HIGH)
        
        $display("=== Iniciando Simulação do Processador MIPS ===");
        $display("Tempo |   PC   | Saida ULA | Saida D-MEM");
        $display("------------------------------------------");

        // Monitora as saídas principais a cada mudança
        $monitor("%4t  | %h | %h  | %h", $time, pc_out, ula_out, dmem_out);

        // Segura o reset por 20ns (2 ciclos de clock) para garantir a inicialização
        #20;
        reset = 0;

        // Deixa o processador rodar por um tempo determinado.
        // O tempo necessário dependerá de quantas instruções tem no seu instruction.list
        #500; 

        $display("=== Fim da Simulação ===");
        $finish;
    end

endmodule

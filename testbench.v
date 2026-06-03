`timescale 1ns / 1ps

module testbench;

    // Sinais de entrada para o processador (reg ou wire conforme a necessidade do testbench)
    reg clock;
    reg reset;

    // Sinais de saída do processador (fios para ler os valores)
    wire [31:0] PC_out;
    wire [31:0] ULA_out;
    wire [31:0] DMem_out;

    // Instanciação do módulo top (o seu núcleo MIPS)
    top meu_mips (
        .clock(clock),
        .reset(reset),
        .PC_out(PC_out),
        .ULA_out(ULA_out),
        .DMem_out(DMem_out)
    );

    // Geração do sinal de relógio (inverte o sinal a cada 5 unidades de tempo)
    always #5 clock = ~clock;

    // Bloco inicial de estímulos
    initial begin
        // Configuração para gerar os gráficos de onda (Waveforms) no EDA Playground / GTKWave
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);

        // Inicialização
        clock = 0;
        reset = 1; // Ativa o reset para limpar o banco de registradores

        // Espera 10 unidades de tempo e desliga o reset
        #10 reset = 0;

        // Deixa a simulação correr por um tempo (ex: 100 unidades de tempo)
        #100;
        
        // Termina a simulação
        $display("Simulação concluída.");
        $finish;
    end

    // Monitorização: imprime no ecrã (console) os valores sempre que o PC muda
    always @(PC_out) begin
        // Usamos %0d para decimal e %h para hexadecimal
        $display("Tempo=%0t | PC=%0d | Saida ULA=%0d | Saida Memoria=%0d", 
                 $time, PC_out, ULA_out, DMem_out);
    end

endmodule
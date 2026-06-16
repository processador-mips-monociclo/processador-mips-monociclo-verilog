`timescale 1ns / 1ps

module testbench;

    reg clock;
    reg reset;

    wire [31:0] PC_out;
    wire [31:0] ULA_out;
    wire [31:0] DMem_out;

    top meu_mips (
        .clock(clock),
        .reset(reset),
        .PC_out(PC_out),
        .ULA_out(ULA_out),
        .DMem_out(DMem_out)
    );

    always #5 clock = ~clock;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);

        clock = 0;
        reset = 1;

        #10 reset = 0;
        #100;
        
        $display("Simulação concluída.");
        $finish;
    end

    always @(PC_out) begin
        $display("Tempo=%0t | PC=%0d | Saida ULA=%0d | Saida Memoria=%0d", 
                 $time, PC_out, ULA_out, DMem_out);
    end

endmodule
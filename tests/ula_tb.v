`timescale 1ns / 1ps // Padroniza o tempo da simulação <unidade de tempo>/<precisão do tempo>
// Logo #10 é 10ns de espera com 1ps de precisão
// É usado para simular o clock na ula
module ula_tb;

    reg  [31:0] in1, in2;
    reg  [3:0]  op;
    wire [31:0] result;
    wire        zero_flag;

    ula uut (.in1(in1), .in2(in2), .op(op), .result(result), .zero_flag(zero_flag)); // instânciando a ula

    integer passou, falhou;

    // Função para o benchmark dos testes
    task testar;
        input [3:0]  t_op;
        input [31:0] t_in1, t_in2, t_esperado;
        input        t_zero;
        begin
            op = t_op; in1 = t_in1; in2 = t_in2;
            #10;
            if (result === t_esperado && zero_flag === t_zero) begin
                $display("PASS | op=%b in1=%h in2=%h | result=%h", t_op, t_in1, t_in2, result);
                passou = passou + 1;
            end else begin
                $display("FAIL | op=%b in1=%h in2=%h | esp=%h got=%h | zero esp=%b got=%b",
                    t_op, t_in1, t_in2, t_esperado, result, t_zero, zero_flag);
                falhou = falhou + 1;
            end
        end
    endtask


    initial begin
        $dumpfile("tests/out/ula_tb.vcd"); // Especifica o caminho do executável para a simulação
        $dumpvars(0, ula_tb);   // Usa as variáveis deste módulo
        passou = 0; falhou = 0;

        $display("=== Iniciando testes da ULA ===");

        // Adição
        testar(4'b0000, 32'd15,      32'd10,      32'd25,       0); // 15+10=25 zero_flag=0
        testar(4'b0000, 32'd0,       32'd0,       32'd0,        1); // 0 + 0=0 zero_flag=1
        testar(4'b0000, 32'hFFFFFFFF,32'd1,       32'd0,        1); // -MAX+1=0 zero_flag=1
        // Subtração
        testar(4'b0001, 32'd20,      32'd8,       32'd12,       0); // 20-8=12 zero_flag=0
        testar(4'b0001, 32'd5,       32'd5,       32'd0,        1); // 5-5=0 zero_flag=1
        // AND
        testar(4'b0010, 32'hFF00FF00,32'hF0F0F0F0,32'hF000F000, 0); // mantém somente os bits iguais, zero_flag=0
        testar(4'b0010, 32'hAAAAAAAA,32'h55555555,32'd0,        1); // tudo diferente, zero_flag=1
        // OR
        testar(4'b0011, 32'hFF000000,32'h00FF0000,32'hFFFF0000, 0); // mantém bits com 1, zero_flag=0
        // XOR
        testar(4'b0100, 32'hFFFFFFFF,32'hFFFFFFFF,32'd0,        1); // 1 somente com bits diferentes, zero_flag=1
        // NOR
        testar(4'b0101, 32'h00000000,32'h00000000,32'hFFFFFFFF, 0); // 0 NOR 0 = tudo 1, zero_flag=0
        testar(4'b0101, 32'hFFFFFFFF,32'h00000000,32'h00000000, 1); // 1 NOR 0 = 0, zero_flag=1
        // SLL
        testar(4'b0110, 32'd4,       32'd1,       32'd16,       0); // 4 << 1 = 4*2 = 16 (shift com zeros à direita)
        testar(4'b0110, 32'd0,       32'd99,      32'd99,       0); // 0 << 99 = 0 (shift 0 posições), zero_flag=0
        // SRL (lógico)
        testar(4'b0111, 32'd4,       32'd16,      32'd1,        0); // 16 >> 4 = 1 (shift lógico com zeros à esquerda)
        testar(4'b0111, 32'd1,       32'hFFFFFFFF,32'h7FFFFFFF, 0); // MAX >> 1 = MAX/2 com zero a esquerda, zero_flag=0
        // SRA (aritmético)
        testar(4'b1000, 32'd1,       32'hFFFFFFFF,32'hFFFFFFFF, 0); // -1 >> 1 = -1 (propaga sinal), zero_flag=0
        testar(4'b1000, 32'd1,       32'd16,      32'd8,        0); // 16 >> 1 = 8 (shift aritmético), zero_flag=0
        // SLT
        testar(4'b1001, 32'd3,       32'd7,       32'd1,        0); // 3 < 7 = 1 (verdadeiro), zero_flag=0
        testar(4'b1001, 32'd7,       32'd3,       32'd0,        1); // 7 < 3 = 0 (falso), zero_flag=1
        testar(4'b1001, 32'hFFFFFFFF,32'd1,       32'd1,        0); // -1 < 1 = 1 (comparação com sinal), zero_flag=0
        // SLTU
        testar(4'b1010, 32'hFFFFFFFF,32'd1,       32'd0,        1); // MAX < 1 = 0 sem sinal, zero_flag=1
        testar(4'b1010, 32'd1,       32'hFFFFFFFF,32'd1,        0); // 1 < MAX = 1 sem sinal, zero_flag=0
        // LUI
        testar(4'b1011, 32'd0,       32'hABCD0000,32'hABCD0000, 0); // LUI carrega in2 como resultado, zero_flag=0

        $display("=== %0d passou, %0d falhou ===", passou, falhou);
        $finish;
    end

endmodule
/*
    Alunos: Matheus Aroxa, Davyson farias, Lucas Carvalho
    AOC 2026.1
    Descrição: Este módulo é responsável por integrar os demais componentes
*/
module top (
    input wire clock,      // Sinal de clock para sincronização
    input wire reset,      // Sinal de reset assíncrono para o PC/Registradores
    output wire [31:0] PC_out,   // Monitoramento do endereço atual
    output wire [31:0] ULA_out,  // Monitoramento do resultado da ULA
    output wire [31:0] DMem_out  // Monitoramento do dado lido da memória
);

    // Declaração de fios internos para interconexão
    wire [31:0] pc_atual, next_pc, pc_mais_4;
    wire [31:0] instruction;
    
    // Sinais de controle vindos da Unidade de Controle
    wire [1:0] RegDst, MemtoReg;
    wire ALUSrc, RegWrite, MemRead, MemWrite, Branch, Bne, Jump;
    wire [3:0] ALUOp;
    
    // Sinais do Banco de Registradores
    wire [4:0] write_reg_addr;
    wire [31:0] write_data, read_data1, read_data2;
    
    // Sinais da ULA
    wire [3:0] ula_op_final;
    wire [31:0] alu_in2, alu_result;
    wire zero_flag;
    
    // Dado lido da memória
    wire [31:0] read_data_mem;
    
    // Sinais para endereçamento de salto
    wire [31:0] sign_ext_imm, shifted_imm, branch_target, jump_target;
    wire branch_taken;

    // Conexões para os outputs de monitoramento
    assign PC_out = pc_atual;
    assign ULA_out = alu_result;
    assign DMem_out = read_data_mem;

    // Lógica do PC: incremento sequencial de 4 bytes (32 bits)
    assign pc_mais_4 = pc_atual + 32'd4;
    
    // Extensão de sinal do imediato (de 16 para 32 bits) e deslocamento para endereçamento
    assign sign_ext_imm = {{16{instruction[15]}}, instruction[15:0]};
    assign shifted_imm = sign_ext_imm << 2;
    
    // Cálculo dos endereços de destino para desvios e saltos
    assign branch_target = pc_mais_4 + shifted_imm;
    assign jump_target = {pc_mais_4[31:28], instruction[25:0], 2'b00};
    
    // Lógica para determinar se o desvio (Branch) ou salto (Jump) será executado
    assign branch_taken = (Branch & zero_flag) | (Bne & ~zero_flag);
    assign next_pc = Jump ? jump_target : (branch_taken ? branch_target : pc_mais_4);

    // Mux: Seleção do registrador de destino (rd, rt ou $ra)
    assign write_reg_addr = (RegDst == 2'b01) ? instruction[15:11] : 
                            (RegDst == 2'b10) ? 5'd31 : instruction[20:16];
                            
    // Mux: Escolha entre registrador ou valor imediato para a ULA
    assign alu_in2 = ALUSrc ? sign_ext_imm : read_data2;
    
    // Mux: Seleção do dado a ser gravado no banco (memória, ULA ou PC+4)
    assign write_data = (MemtoReg == 2'b01) ? read_data_mem : 
                        (MemtoReg == 2'b10) ? pc_mais_4 : alu_result;

    // --- Instanciação dos Componentes do Processador ---

    // PC: Registrador que guarda o endereço da instrução
    pc meu_pc (
        .clock(clock),
        .nextpc(next_pc),
        .pc(pc_atual)
    );

    // Memória de Instrução: Fornece a instrução baseada no PC
    i_mem minha_mem_instrucao (
        .address(pc_atual),
        .i_out(instruction)
    );

    // Unidade de Controle: Decodifica o Opcode em sinais de controle
    ctrl minha_unidade_controlo (
        .Opcode(instruction[31:26]),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .Bne(Bne),
        .Jump(Jump),
        .ALUOp(ALUOp)
    );

    // Banco de Registradores: Realiza leitura/escrita de dados
    regfile meu_banco_registradores (
        .clock(clock),
        .regWrite(RegWrite),
        .reset(reset),
        .readAddr1(instruction[25:21]),
        .readAddr2(instruction[20:16]),
        .writeAddr(write_reg_addr),
        .writeData(write_data),
        .readData1(read_data1),
        .readData2(read_data2)
    );

    // Controle da ULA: Define a operação específica baseada no campo Funct
    ula_ctrl meu_controlo_ula (
        .ALUOp(ALUOp),
        .Funct(instruction[5:0]),
        .ula_OP(ula_op_final)
    );

    // ULA: Executa as operações aritméticas e lógicas
    ula minha_ula (
        .in1(read_data1),
        .in2(alu_in2),
        .op(ula_op_final),
        .result(alu_result),
        .zero_flag(zero_flag)
    );

    // Memória de Dados: Acesso para operações de Load/Store
    d_mem minha_mem_dados (
        .Address(alu_result),
        .WriteData(read_data2),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ReadData(read_data_mem)
    );

endmodule
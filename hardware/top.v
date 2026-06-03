module top (
    input wire clock,
    input wire reset,
    output wire [31:0] PC_out,
    output wire [31:0] ULA_out,
    output wire [31:0] DMem_out
);

    wire [31:0] pc_atual, next_pc, pc_mais_4;
    wire [31:0] instruction;
    
    wire [1:0] RegDst, MemtoReg;
    wire ALUSrc, RegWrite, MemRead, MemWrite, Branch, Bne, Jump;
    wire [3:0] ALUOp;
    
    wire [4:0] write_reg_addr;
    wire [31:0] write_data, read_data1, read_data2;
    
    wire [3:0] ula_op_final;
    wire [31:0] alu_in2, alu_result;
    wire zero_flag;
    
    wire [31:0] read_data_mem;
    
    wire [31:0] sign_ext_imm, shifted_imm, branch_target, jump_target;
    wire branch_taken;

    assign PC_out = pc_atual;
    assign ULA_out = alu_result;
    assign DMem_out = read_data_mem;

    assign pc_mais_4 = pc_atual + 32'd4;
    
    assign sign_ext_imm = {{16{instruction[15]}}, instruction[15:0]};
    assign shifted_imm = sign_ext_imm << 2;
    
    assign branch_target = pc_mais_4 + shifted_imm;
    assign jump_target = {pc_mais_4[31:28], instruction[25:0], 2'b00};
    
    assign branch_taken = (Branch & zero_flag) | (Bne & ~zero_flag);
    assign next_pc = Jump ? jump_target : (branch_taken ? branch_target : pc_mais_4);
    
    assign write_reg_addr = (RegDst == 2'b01) ? instruction[15:11] : 
                            (RegDst == 2'b10) ? 5'd31 : instruction[20:16];
                            
    assign alu_in2 = ALUSrc ? sign_ext_imm : read_data2;
    
    assign write_data = (MemtoReg == 2'b01) ? read_data_mem : 
                        (MemtoReg == 2'b10) ? pc_mais_4 : alu_result;

    pc meu_pc (
        .clock(clock),
        .nextPC(next_pc),
        .PC(pc_atual)
    );

    i_mem minha_mem_instrucao (
        .address(pc_atual),
        .i_out(instruction)
    );

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

    ula_ctrl meu_controlo_ula (
        .ALUOp(ALUOp),
        .Funct(instruction[5:0]),
        .ula_OP(ula_op_final)
    );

    ula minha_ula (
        .in1(read_data1),
        .in2(alu_in2),
        .op(ula_op_final),
        .result(alu_result),
        .zero_flag(zero_flag)
    );

    d_mem minha_mem_dados (
        .Address(alu_result),
        .WriteData(read_data2),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ReadData(read_data_mem)
    );

endmodule
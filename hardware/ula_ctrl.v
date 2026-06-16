/*
    Alunos: Matheus Aroxa, Davyson farias, Lucas Carvalho
    AOC 2026.1
    Descrição: Decodificador de controle da ULA. Este módulo recebe o sinal ALUOp da 
    unidade de controle e o campo Funct da instrução para determinar qual operação 
    específica a ULA deve realizar.
*/
module ula_ctrl (
    input [3:0] ALUOp,
    input [5:0] Funct,
    output reg [3:0] ula_OP
);

    always @(*) begin
        case (ALUOp)
            // Quando ALUOp é 0000, trata-se de instrução Tipo-R; 
            // a operação exata é determinada pelo campo 'Funct'
            4'b0000: begin
                case (Funct)
                    6'b100000: ula_OP = 4'b0000; // ADD
                    6'b100010: ula_OP = 4'b0001; // SUB
                    6'b100100: ula_OP = 4'b0010; // AND
                    6'b100101: ula_OP = 4'b0011; // OR
                    6'b100110: ula_OP = 4'b0100; // XOR
                    6'b100111: ula_OP = 4'b0101; // NOR
                    6'b101010: ula_OP = 4'b1001; // SLT (Set Less Than)
                    6'b101011: ula_OP = 4'b1010; // SLTU (Set Less Than Unsigned)
                    
                    // Operações de Shift (Exemplos de mapeamento)
                    6'b000000: ula_OP = 4'b0110; // SLL
                    6'b000010: ula_OP = 4'b0111; // SRL
                    6'b000011: ula_OP = 4'b1000; // SRA
                    6'b000111: ula_OP = 4'b1000; // SRA (repetido/variante)
                    6'b000100: ula_OP = 4'b0110; // SLLV
                    6'b000110: ula_OP = 4'b0111; // SRLV
                    
                    default:   ula_OP = 4'b0000; // Operação padrão (NOP/ADD)
                endcase
            end

            // Instruções que não dependem do campo 'Funct' (Instruções I-Type)
            4'b0001: ula_OP = 4'b0000; // ADD (ex: ADDI, LW, SW)
            4'b0010: ula_OP = 4'b0001; // SUB (ex: BEQ, BNE)
            4'b0011: ula_OP = 4'b0010; // AND (ex: ANDI)
            4'b0100: ula_OP = 4'b0011; // OR  (ex: ORI)
            4'b0101: ula_OP = 4'b0100; // XOR (ex: XORI)
            4'b0110: ula_OP = 4'b1001; // SLT (ex: SLTI)
            4'b0111: ula_OP = 4'b1010; // SLTU(ex: SLTIU)
            4'b1000: ula_OP = 4'b1011; // LUI (Load Upper Immediate)
            
            default: ula_OP = 4'b0000;
        endcase
    end
endmodule
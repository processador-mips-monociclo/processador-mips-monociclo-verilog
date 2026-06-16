module ula_ctrl (
    input [3:0] ALUOp,
    input [5:0] Funct,
    output reg [3:0] ula_OP
);

    always @(*) begin
        case (ALUOp)
            4'b0000: begin
                case (Funct)
                    6'b100000: ula_OP = 4'b0000;
                    6'b100010: ula_OP = 4'b0001;
                    6'b100100: ula_OP = 4'b0010; 
                    6'b100101: ula_OP = 4'b0011;
                    6'b100110: ula_OP = 4'b0100; 
                    6'b100111: ula_OP = 4'b0101;
                    6'b101010: ula_OP = 4'b1001; 
                    6'b101011: ula_OP = 4'b1010; 
                    
                    // Operações de Shift
                    6'b000000: ula_OP = 4'b0110;
                    6'b000010: ula_OP = 4'b0111;
                    6'b000011: ula_OP = 4'b1000;
                    6'b000111: ula_OP = 4'b1000; 
                    6'b000100: ula_OP = 4'b0110;
                    6'b000110: ula_OP = 4'b0111;
                    
                    default:   ula_OP = 4'b0000;
                endcase
            end

            
            4'b0001: ula_OP = 4'b0000; 
            4'b0010: ula_OP = 4'b0001; 
            4'b0011: ula_OP = 4'b0010; 
            4'b0100: ula_OP = 4'b0011; 
            4'b0101: ula_OP = 4'b0100;
            4'b0110: ula_OP = 4'b1001;
            4'b0111: ula_OP = 4'b1010;
            4'b1000: ula_OP = 4'b1011;
            
            default: ula_OP = 4'b0000;
        endcase
    end
endmodule
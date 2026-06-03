ULA_SRC = ./hardware/ula.v ./tests/ula_tb.v

ula:
	iverilog -o ula_sim $(ULA_SRC)
	vvp ula_sim

clean:
	rm -f ula_sim ula_tb.vcd

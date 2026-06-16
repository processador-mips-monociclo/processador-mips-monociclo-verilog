HW_SRC = $(wildcard ./hardware/*.v)
ULA_TB = ./tests/ula_tb.v
TOP_TB = ./testbench.v

OUT_DIR = ./tests/out

all: top

top:
	@mkdir -p $(OUT_DIR)
	iverilog -o $(OUT_DIR)/top_sim $(HW_SRC) $(TOP_TB)
	vvp $(OUT_DIR)/top_sim

ula:
	@mkdir -p $(OUT_DIR)
	iverilog -o $(OUT_DIR)/ula_sim ./hardware/ula.v $(ULA_TB)
	vvp $(OUT_DIR)/ula_sim

clean:
	rm -rf $(OUT_DIR)/*_sim $(OUT_DIR)/*.vcd
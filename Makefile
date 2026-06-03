.PHONY: run run_self run_mux wave wave_self wave_mux clean

run:
	iverilog -g2012 -o sim/demux.out rtl/demux1x8.v tb/demux1x8_tb.sv
	vvp sim/demux.out

run_self:
	iverilog -g2012 -o sim/demux_self.out rtl/demux1x8.v tb/demux1x8_tb_selfcheck.sv
	vvp sim/demux_self.out

run_mux:
	iverilog -g2012 -o sim/mux.out rtl/8x1mux.v tb/tb_8x1mux.sv
	vvp sim/mux.out

wave:
	gtkwave sim/demux1x8_tb.vcd

wave_self:
	gtkwave sim/demux1x8_selfcheck.vcd

wave_mux:
	gtkwave sim/mux8x1_tb.vcd

run_mux_self:
	iverilog -g2012 -o sim/mux_self.out rtl/8x1mux.v tb/tb_8x1mux_selfcheck.sv
	vvp sim/mux_self.out

wave_mux_self:
	gtkwave sim/mux8x1_selfcheck.vcd
run_decoder:
	iverilog -g2012 -o sim/decoder.out rtl/decoder2x4.v tb/tb_decoder2x4.v
	vvp sim/decoder.out

wave_decoder:
	gtkwave sim/decoder2x4_tb.vcd
clean:
	rm -f sim/*.out sim/*.vcd

run_decoder_self:
	iverilog -g2012 -o sim/decoder_self.out rtl/decoder2x4.v tb/tb_decoder2x4_selfcheck.sv
	vvp sim/decoder_self.out

wave_decoder_self:
	gtkwave sim/decoder2x4_selfcheck.vcd
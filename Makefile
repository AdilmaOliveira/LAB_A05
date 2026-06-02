.PHONY: run run_self wave wave_self clean

run:
	iverilog -g2012 -o sim/demux.out rtl/demux1x8.v tb/demux1x8_tb.sv
	vvp sim/demux.out

run_self:
	iverilog -g2012 -o sim/demux_self.out rtl/demux1x8.v tb/demux1x8_tb_selfcheck.sv
	vvp sim/demux_self.out

wave:
	gtkwave sim/demux1x8_tb.vcd

wave_self:
	gtkwave sim/demux1x8_selfcheck.vcd

clean:
	rm -f sim/*.out sim/*.vcd

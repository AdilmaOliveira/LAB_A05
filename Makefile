.PHONY: run wave clean

run:
	iverilog -g2012 -o sim/demux.out rtl/demux1x8.v tb/demux1x8_tb.sv
	vvp sim/demux.out

wave:
	gtkwave sim/demux1x8_tb.vcd

clean:
	rm -f sim/*.out sim/*.vcd
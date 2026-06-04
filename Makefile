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

run_encoder:
	iverilog -g2012 -o sim/encoder.out rtl/encoder4x2.v tb/tb_encoder4x2.v
	vvp sim/encoder.out

wave_encoder:
	gtkwave sim/encoder4x2_tb.vcd

run_encoder_self:
	iverilog -g2012 -o sim/encoder_self.out rtl/encoder4x2.v tb/tb_encoder4x2_selfcheck.sv
	vvp sim/encoder_self.out

wave_encoder_self:
	gtkwave sim/encoder4x2_selfcheck.vcd
run_arbiter:
	iverilog -g2012 -o sim/arbiter.out rtl/arbiter.v tb/tb_arbiter.v
	vvp sim/arbiter.out

wave_arbiter:
	gtkwave sim/arbiter_tb.vcd
run_arbiter_self:
	iverilog -g2012 -o sim/arbiter_self.out rtl/arbiter.v tb/tb_arbiter_selfcheck.sv
	vvp sim/arbiter_self.out

wave_arbiter_self:
	gtkwave sim/arbiter_selfcheck.vcd
run_counter:
	iverilog -g2012 -o sim/counter.out rtl/counter32bit.v tb/tb_counter32bit.v
	vvp sim/counter.out

wave_counter:
	gtkwave sim/counter_overflow_tb.vcd

run_counter_self:
	iverilog -g2012 -o sim/counter_self.out rtl/counter32bit.v tb/tb_counter32bit_selfcheck.sv
	vvp sim/counter_self.out

wave_counter_self:
	gtkwave sim/counter_overflow_selfcheck.vcd
run_updown:
	iverilog -g2012 -o sim/updown.out rtl/updown_counter.v tb/tb_updown_counter.v
	vvp sim/updown.out

wave_updown:
	gtkwave sim/updown_counter_tb.vcd

run_updown_self:
	iverilog -g2012 -o sim/updown_self.out rtl/updown_counter.v tb/tb_updown_counter_selfcheck.sv
	vvp sim/updown_self.out

wave_updown_self:
	gtkwave sim/updown_counter_selfcheck.vcd
run_adder:
	iverilog -g2012 -o sim/adder.out rtl/adder32.v tb/tb_adder32.v
	vvp sim/adder.out

wave_adder:
	gtkwave sim/adder32_tb.vcd
run_adder_self:
	iverilog -g2012 -o sim/adder_self.out rtl/adder32.v tb/tb_adder32_selfcheck.sv
	vvp sim/adder_self.out

wave_adder_self:
	gtkwave sim/adder32_selfcheck.vcd
run_multiplier:
	iverilog -g2012 -o sim/multiplier.out rtl/multiplier16x16.v tb/tb_multiplier16x16.v
	vvp sim/multiplier.out

wave_multiplier:
	gtkwave sim/multiplier_tb.vcd
run_multiplier_self:
	iverilog -g2012 -o sim/multiplier_self.out rtl/multiplier16x16.v tb/tb_multiplier16x16_selfcheck.sv
	vvp sim/multiplier_self.out

wave_multiplier_self:
	gtkwave sim/multiplier_selfcheck.vcd
run_matrix:
	iverilog -g2012 -o sim/matrix.out rtl/matrixmult.v tb/tb_matrixmult.v
	vvp sim/matrix.out

wave_matrix:
	gtkwave sim/matrix2x2_mult_tb.vcd
run_matrix_self:
	iverilog -g2012 -o sim/matrix_self.out rtl/matrixmult.v tb/tb_matrixmult_selfcheck.sv
	vvp sim/matrix_self.out

wave_matrix_self:
	gtkwave sim/matrix2x2_mult_selfcheck.vcd
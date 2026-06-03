//Function: The test bench applies random values to 4-bit din and checks the encoded
//2-bit dout. The waveform encoder4x2_tb.vcd can be observed using waveform
//viewer.
// Testbench with self-checking for encoder4x2

module encoder4x2_tb;

// Inputs
logic [3:0] din;
logic en;
logic clk;
logic rstn;

// Outputs
logic [1:0] dout;

// Self-checking
logic [1:0] expected;

int match;
int mismatch;
int tr;

// Time measurement
time start_time;
time end_time;
real avg_time_per_test;

// Clock generation
always #5 clk = ~clk;

// Reference Model
task refmod(
    input logic en_i,
    input logic [3:0] din_i,
    output logic [1:0] exp
);
begin
    exp = 2'b00;

    if (en_i) begin
        case (din_i)
            4'b0001: exp = 2'b00;
            4'b0010: exp = 2'b01;
            4'b0100: exp = 2'b10;
            4'b1000: exp = 2'b11;
            default: exp = 2'b00;
        endcase
    end
end
endtask

initial begin
    clk = 0;
    rstn = 0;
    en = 0;
    din = 4'b0000;
    expected = 2'b00;

    match = 0;
    mismatch = 0;
    tr = 0;

    start_time = $time;

    $display("--------- Test Started ---------");

    // Reset
    #10 rstn = 0;
    #10 rstn = 1;

    en = 1;

    // Valid encoder inputs
    for (int i = 0; i < 4; i++) begin
        din = 4'b0001 << i;

        refmod(en, din, expected);

        @(posedge clk);
        #1;

        if (dout !== expected) begin
            $display("FAIL: din=%b expected=%b got=%b", din, expected, dout);
            mismatch++;
        end else begin
            $display("PASS: din=%b expected=%b got=%b", din, expected, dout);
            match++;
        end

        tr++;
    end

    end_time = $time;

    if (tr > 0)
        avg_time_per_test = real'(end_time - start_time) / tr;
    else
        avg_time_per_test = 0.0;

    $display("\n======================");
    $display("FINAL REPORT");
    $display("======================");
    $display("Stimuli Applied       : %0d", tr);
    $display("PASS                  : %0d", match);
    $display("FAIL                  : %0d", mismatch);
    $display("Execution Time        : %0t", end_time - start_time);
    $display("Average Time/Test     : %0.2f", avg_time_per_test);
    $display("======================\n");

    #20;
    $finish;
end

encoder4x2 uut (
    .clk(clk),
    .din(din),
    .dout(dout),
    .rstn(rstn),
    .en(en)
);

initial begin
    $dumpfile("sim/encoder4x2_selfcheck.vcd");
    $dumpvars(0, encoder4x2_tb);
end

endmodule
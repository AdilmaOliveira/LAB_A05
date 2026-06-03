// Testbench with self-checking for counter_overflow

module counter_overflow_tb;

// Inputs
logic clk;
logic reset_n;
logic en;
logic load;

// Outputs
logic [31:0] counter_out;
logic counter_overflow;

// Self-checking
logic [32:0] expected_counter;
logic [31:0] expected_counter_out;
logic expected_overflow;

int match;
int mismatch;
int tr;

// Time measurement
time start_time;
time end_time;
real avg_time_per_test;

// Clock generation
always #5 clk = ~clk;

// Reference model
task refmod(
    input logic reset_n_i,
    input logic en_i,
    input logic load_i,
    output logic [32:0] exp_counter
);
begin
    if (!reset_n_i)
        exp_counter = 33'd0;

    if (en_i)
        exp_counter = exp_counter + 1;

    if (load_i)
        exp_counter = 33'b0_11111111111111111111111111111000;
end
endtask

task check_result;
begin
    expected_counter_out = expected_counter[31:0];
    expected_overflow    = expected_counter[32];

    if ((counter_out !== expected_counter_out) ||
        (counter_overflow !== expected_overflow)) begin

        $display("FAIL: expected_counter=%h expected_out=%h expected_ovf=%0b got_out=%h got_ovf=%0b",
                 expected_counter,
                 expected_counter_out,
                 expected_overflow,
                 counter_out,
                 counter_overflow);

        mismatch++;

    end else begin

        $display("PASS: expected_out=%h expected_ovf=%0b got_out=%h got_ovf=%0b",
                 expected_counter_out,
                 expected_overflow,
                 counter_out,
                 counter_overflow);

        match++;

    end

    tr++;
end
endtask

task apply_and_check(
    input logic en_i,
    input logic load_i
);
begin
    en   = en_i;
    load = load_i;

    @(posedge clk);
    #1;

    refmod(reset_n, en, load, expected_counter);

    check_result();
end
endtask

initial begin
    clk = 0;
    reset_n = 0;
    en = 0;
    load = 0;

    expected_counter = 33'd0;
    expected_counter_out = 32'd0;
    expected_overflow = 1'b0;

    match = 0;
    mismatch = 0;
    tr = 0;

    start_time = $time;

    $display("--------- Test Started ---------");

    // Reset
    #10 reset_n = 0;
    @(posedge clk);
    #1;
    refmod(reset_n, en, load, expected_counter);
    check_result();

    // Release reset
    reset_n = 1;

    // Enable counter for a few cycles
    repeat (5) begin
        apply_and_check(1, 0);
    end

    // Load value close to overflow
    apply_and_check(0, 1);

    // Disable load and continue counting to reach overflow
    repeat (12) begin
        apply_and_check(1, 0);
    end

    // Disable counter and verify it holds value
    repeat (3) begin
        apply_and_check(0, 0);
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

counter_overflow uut (
    .clk(clk),
    .reset_n(reset_n),
    .en(en),
    .counter_out(counter_out),
    .counter_overflow(counter_overflow),
    .load(load)
);

initial begin
    $dumpfile("sim/counter_overflow_selfcheck.vcd");
    $dumpvars(0, counter_overflow_tb);
end

endmodule
// Testbench with self-checking for updown_counter

module updown_counter_tb;

// Inputs
logic clk;
logic resetn;
logic en;

// Outputs
logic [3:0] up_counter;
logic [3:0] down_counter;

// Self-checking
logic [3:0] expected_up;
logic [3:0] expected_down;

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
    input logic resetn_i,
    input logic en_i,
    inout logic [3:0] exp_up,
    inout logic [3:0] exp_down
);
begin
    if (!resetn_i) begin
        exp_up   = 4'h0;
        exp_down = 4'hF;
    end
    else if (en_i) begin
        exp_up   = exp_up + 1'b1;
        exp_down = exp_down - 1'b1;
    end
end
endtask

task check_result;
begin
    if ((up_counter !== expected_up) || (down_counter !== expected_down)) begin
        $display("FAIL: expected_up=%h expected_down=%h got_up=%h got_down=%h",
                 expected_up, expected_down, up_counter, down_counter);
        mismatch++;
    end else begin
        $display("PASS: expected_up=%h expected_down=%h got_up=%h got_down=%h",
                 expected_up, expected_down, up_counter, down_counter);
        match++;
    end

    tr++;
end
endtask

task apply_and_check(
    input logic en_i
);
begin
    en = en_i;

    refmod(resetn, en, expected_up, expected_down);

    @(posedge clk);
    #1;

    check_result();
end
endtask

initial begin
    clk = 0;
    resetn = 0;
    en = 0;

    expected_up = 4'h0;
    expected_down = 4'hF;

    match = 0;
    mismatch = 0;
    tr = 0;

    start_time = $time;

    $display("--------- Test Started ---------");

    // Reset check
    @(posedge clk);
    #1;
    refmod(resetn, en, expected_up, expected_down);
    check_result();

    // Release reset and synchronize reference model with DUT
    resetn = 1;
    en = 1;

    @(posedge clk);
    #1;

    expected_up   = up_counter;
    expected_down = down_counter;

    $display("SYNC: expected_up=%h expected_down=%h got_up=%h got_down=%h",
             expected_up, expected_down, up_counter, down_counter);

    // Main counting test
    repeat (20) begin
        apply_and_check(1);
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

updowncounter uut (
    .clk(clk),
    .resetn(resetn),
    .en(en),
    .up_counter(up_counter),
    .down_counter(down_counter)
);

initial begin
    $dumpfile("sim/updown_counter_selfcheck.vcd");
    $dumpvars(0, updown_counter_tb);
end

endmodule
// Testbench with self-checking for 32-bit adder

module adder_tb;

// Inputs
logic clk;
logic reset_n;
logic en;
logic [31:0] A;
logic [31:0] B;

// Outputs
logic [31:0] sum;
logic carry_out;

// Reference model
logic [32:0] expected_result;
logic [31:0] expected_sum;
logic expected_carry;

// Statistics
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
    input logic [31:0] a_i,
    input logic [31:0] b_i
);
begin
    expected_result = a_i + b_i;
    expected_sum    = expected_result[31:0];
    expected_carry  = expected_result[32];
end
endtask

task apply_and_check(
    input logic [31:0] a_i,
    input logic [31:0] b_i
);
begin

    A = a_i;
    B = b_i;

    refmod(A, B);

    @(posedge clk);
    #1;

    if ((sum !== expected_sum) ||
        (carry_out !== expected_carry)) begin

        $display("FAIL: A=%h B=%h expected_sum=%h expected_carry=%0b got_sum=%h got_carry=%0b",
                 A, B,
                 expected_sum,
                 expected_carry,
                 sum,
                 carry_out);

        mismatch++;

    end
    else begin

        $display("PASS: A=%h B=%h expected_sum=%h expected_carry=%0b",
                 A, B,
                 expected_sum,
                 expected_carry);

        match++;

    end

    tr++;

end
endtask

initial begin

    clk = 0;
    reset_n = 0;
    en = 0;
    A = 0;
    B = 0;

    match = 0;
    mismatch = 0;
    tr = 0;

    start_time = $time;

    $display("--------- Test Started ---------");

    // Reset
    #10 reset_n = 0;
    #10 reset_n = 1;
    en = 1;

    // Same vectors used in original TB
    apply_and_check(32'hAAAAAAAA, 32'hEEEEEEEE);
    apply_and_check(32'h07777777, 32'h02456321);
    apply_and_check(32'hCCCCCCCC, 32'h0BBBBBBB);
    apply_and_check(32'h11111111, 32'h11111111);

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

adder uut (
    .clk(clk),
    .reset_n(reset_n),
    .en(en),
    .op_a(A),
    .op_b(B),
    .adder_out(sum),
    .carry_out(carry_out)
);

initial begin
    $dumpfile("sim/adder32_selfcheck.vcd");
    $dumpvars(0, adder_tb);
end

endmodule
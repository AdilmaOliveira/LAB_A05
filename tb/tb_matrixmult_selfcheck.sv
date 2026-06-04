// Testbench with self-checking for 2x2 matrix multiplication

module matrix2x2_mult_tb;

logic [31:0] A;
logic [31:0] B;
logic clk;
logic rstn;
logic en;

logic [31:0] Res;
logic [31:0] expected_res;

int match;
int mismatch;
int tr;

time start_time;
time end_time;
real avg_time_per_test;

always #5 clk = ~clk;

task refmod(
    input logic [31:0] A_i,
    input logic [31:0] B_i,
    output logic [31:0] exp
);
    logic [7:0] A00, A01, A10, A11;
    logic [7:0] B00, B01, B10, B11;
    logic [7:0] R00, R01, R10, R11;
begin
    {A00, A01, A10, A11} = A_i;
    {B00, B01, B10, B11} = B_i;

    R00 = ((A00 * B00) + (A01 * B10)) & 8'hFF;
    R01 = ((A00 * B01) + (A01 * B11)) & 8'hFF;
    R10 = ((A10 * B00) + (A11 * B10)) & 8'hFF;
    R11 = ((A10 * B01) + (A11 * B11)) & 8'hFF;

    exp = {R00, R01, R10, R11};
end
endtask

task apply_and_check(
    input logic [31:0] A_i,
    input logic [31:0] B_i
);
begin
    A = A_i;
    B = B_i;

    refmod(A, B, expected_res);

    @(posedge clk);
    #1;

    if (Res !== expected_res) begin
        $display("FAIL: A=%h B=%h expected=%h got=%h",
                 A, B, expected_res, Res);
        mismatch++;
    end else begin
        $display("PASS: A=%h B=%h expected=%h got=%h",
                 A, B, expected_res, Res);
        match++;
    end

    tr++;
end
endtask

initial begin
    clk = 0;
    rstn = 0;
    en = 0;
    A = 0;
    B = 0;
    expected_res = 0;

    match = 0;
    mismatch = 0;
    tr = 0;

    start_time = $time;

    $display("--------- Test Started ---------");

    #10 rstn = 0;
    #10 rstn = 1;

    en = 1;

    apply_and_check(32'h01010101, 32'h01010101);
    apply_and_check(32'h02020202, 32'h01010101);
    apply_and_check(32'h02020202, 32'h02020202);

    // Additional cases
    apply_and_check(32'h00000000, 32'hFFFFFFFF);
    apply_and_check(32'h01020304, 32'h05060708);
    apply_and_check(32'hFFFFFFFF, 32'h01010101);

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

matrix2x2_mult uut (
    .A(A),
    .B(B),
    .Res(Res),
    .clk(clk),
    .rstn(rstn),
    .en(en)
);

initial begin
    $dumpfile("sim/matrix2x2_mult_selfcheck.vcd");
    $dumpvars(0, matrix2x2_mult_tb);
end

endmodule
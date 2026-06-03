//==============================================================================
// File: arbiter_tb.v
// Description:
//   Simple testbench for the arbiter.
//   Applies requests from client1 and client2 and observes grants.
//==============================================================================
// Testbench with self-checking for arbiter

module arbiter_tb;

// Inputs
logic clk;
logic reset_n;
logic client1_req;
logic client2_req;
logic priority_sel;

// Outputs
logic o_grant1;
logic o_grant2;

// Self-checking
logic expected_grant1;
logic expected_grant2;

int match;
int mismatch;
int tr;

localparam IDLE    = 2'd0;
localparam CLIENT1 = 2'd1;
localparam CLIENT2 = 2'd2;

logic [1:0] exp_state;
logic exp_client1_req_d;
logic exp_client2_req_d;

// Time measurement
time start_time;
time end_time;
real avg_time_per_test;

// Clock generation
always #5 clk = ~clk;

// Reference Model
task refmod(
    input logic c1_req,
    input logic c2_req,
    input logic prio,
    output logic exp_g1,
    output logic exp_g2
);
begin
    exp_g1 = 1'b0;
    exp_g2 = 1'b0;

    if (c1_req && !c2_req) begin
        exp_g1 = 1'b1;
        exp_g2 = 1'b0;
    end
    else if (!c1_req && c2_req) begin
        exp_g1 = 1'b0;
        exp_g2 = 1'b1;
    end
    else if (c1_req && c2_req) begin
        if (prio) begin
            exp_g1 = 1'b1;
            exp_g2 = 1'b0;
        end
        else begin
            exp_g1 = 1'b0;
            exp_g2 = 1'b1;
        end
    end
    else begin
        exp_g1 = 1'b0;
        exp_g2 = 1'b0;
    end
end
endtask

task apply_and_check(
    input logic c1_req,
    input logic c2_req,
    input logic prio
);

    logic [1:0] old_state;
    logic [1:0] next_state;

begin
    client1_req  = c1_req;
    client2_req  = c2_req;
    priority_sel = prio;

    old_state = exp_state;

    case (exp_state)
        IDLE: begin
            if (priority_sel && exp_client1_req_d)
                next_state = CLIENT1;
            else if (exp_client2_req_d)
                next_state = CLIENT2;
            else
                next_state = IDLE;
        end

        CLIENT1: begin
            if (exp_client2_req_d)
                next_state = CLIENT2;
            else
                next_state = IDLE;
        end

        CLIENT2: begin
            if (exp_client1_req_d)
                next_state = CLIENT1;
            else
                next_state = IDLE;
        end

        default: next_state = IDLE;
    endcase

    @(posedge clk);
    #1;

    exp_state = next_state;

    if (old_state == CLIENT1)
        exp_client1_req_d = 0;
    else if (client1_req)
        exp_client1_req_d = 1;

    if (old_state == CLIENT2)
        exp_client2_req_d = 0;
    else if (client2_req)
        exp_client2_req_d = 1;

    expected_grant1 = (exp_state == CLIENT1);
    expected_grant2 = (exp_state == CLIENT2);

    if ((o_grant1 !== expected_grant1) || (o_grant2 !== expected_grant2)) begin
        $display("FAIL: c1_req=%0b c2_req=%0b prio=%0b expected_g1=%0b expected_g2=%0b got_g1=%0b got_g2=%0b",
                 client1_req, client2_req, priority_sel,
                 expected_grant1, expected_grant2,
                 o_grant1, o_grant2);
        mismatch++;
    end else begin
        $display("PASS: c1_req=%0b c2_req=%0b prio=%0b expected_g1=%0b expected_g2=%0b got_g1=%0b got_g2=%0b",
                 client1_req, client2_req, priority_sel,
                 expected_grant1, expected_grant2,
                 o_grant1, o_grant2);
        match++;
    end

    tr++;
end
endtask

initial begin
    clk = 0;
    reset_n = 0;
    client1_req = 0;
    client2_req = 0;
    priority_sel = 0;

    expected_grant1 = 0;
    expected_grant2 = 0;

    match = 0;
    mismatch = 0;
    tr = 0;

    exp_state = IDLE;
    exp_client1_req_d = 0;
    exp_client2_req_d = 0;


    start_time = $time;

    $display("--------- Test Started ---------");

    // Reset
    #10 reset_n = 0;
    #10 reset_n = 1;

    // Stimuli
    apply_and_check(0, 0, 0);
    apply_and_check(1, 0, 0);
    apply_and_check(0, 1, 0);
    apply_and_check(1, 1, 0);

    apply_and_check(0, 0, 1);
    apply_and_check(1, 0, 1);
    apply_and_check(0, 1, 1);
    apply_and_check(1, 1, 1);

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

arbiter uut (
    .clk(clk),
    .reset_n(reset_n),
    .client1_req(client1_req),
    .client2_req(client2_req),
    .priority_sel(priority_sel),
    .o_grant1(o_grant1),
    .o_grant2(o_grant2)
);

initial begin
    $dumpfile("sim/arbiter_selfcheck.vcd");
    $dumpvars(0, arbiter_tb);
end

endmodule
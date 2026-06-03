module decoder2x4_tb;

// Inputs
logic clk;
logic rstn;
logic en;
logic [1:0] din;

// Outputs
logic [3:0] dout;

// Self-checking
logic [3:0] expected;

int match;
int mismatch;
int tr;

// Time measurement
time start_time;
time end_time;
real avg_time_per_test;

always #5 clk = ~clk;

task refmod(
    input logic en_i,
    input logic [1:0] din_i,
    output logic [3:0] exp
);

begin

    exp = 4'b0000;

    if(en_i)
        case(din_i)
            2'b00: exp = 4'b0001;
            2'b01: exp = 4'b0010;
            2'b10: exp = 4'b0100;
            2'b11: exp = 4'b1000;
        endcase

end

endtask

initial begin

    clk = 0;
    rstn = 0;
    en = 0;
    din = 0;

    expected = 0;

    match = 0;
    mismatch = 0;
    tr = 0;
    start_time = $time;

    start_time = $time;

    $display("--------- Test Started ---------");

    #10 rstn = 0;
    #10 rstn = 1;

    en = 1;

        for(int i = 0; i < 4; i++) begin

        din = i[1:0];

        refmod(en, din, expected);

        @(posedge clk);
        #1;

        if(dout !== expected) begin

            $display(
                "FAIL: din=%b expected=%b got=%b",
                din,
                expected,
                dout
            );

            mismatch++;

        end
        else begin

            $display(
                "PASS: din=%b expected=%b got=%b",
                din,
                expected,
                dout
            );

            match++;

        end

        tr++;

    end

        end_time = $time;
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

decoder2x4 uut (
    .clk(clk),
    .rstn(rstn),
    .en(en),
    .din(din),
    .dout(dout)
);

initial begin
    $dumpfile("sim/decoder2x4_selfcheck.vcd");
    $dumpvars(0, decoder2x4_tb);
end

endmodule
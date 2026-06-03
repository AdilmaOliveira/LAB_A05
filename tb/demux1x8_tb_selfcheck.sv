//Function: The test bench applies random values to 3-bit select lines and checks the
//dout. The waveform demux_tb.vcd can be observed using waveform viewer.
//Test bench file: demux3x8_tb.v

module demux1x8_tb;

//Inputs
logic clk;
logic rstn;
logic en;
logic [2:0] sel;
logic din;

//outputs
logic [7:0] dout;
logic [7:0] expected;

int match;
int mismatch;
int tr;

// clock generation
always #5 clk = ~clk; // toggle clock for every 5 ticks

// Reference Model
task refmod(
    input logic en_i,
    input logic [2:0] sel_i,
    input logic din_i,
    output logic [7:0] exp
);
begin
    exp = 8'b00000000;

    if (en_i)
        exp[sel_i] = din_i;
end
endtask

initial begin
    clk = 0;
    rstn = 0;
    en = 0;
    sel = 3'b000;
    din = 1'b0;

    expected = 8'b00000000;
    match = 0;
    mismatch = 0;
    tr = 0;

    $display("--------- Test Started ---------");
        #10 rstn = 0;
        #10 rstn = 1;


    en = 1;

      for (int d = 0; d < 2; d++) begin

    din = d;

    for (int i = 0; i < 8; i++) begin

        sel = i[2:0];

        refmod(en, sel, din, expected);

        @(posedge clk);
        #1;

        if (dout !== expected) begin

            $display(
                "FAIL: din=%0b sel=%0d expected=%b got=%b",
                din,
                sel,
                expected,
                dout
            );

            mismatch++;

        end
        else begin

            $display(
                "PASS: din=%0b sel=%0d expected=%b got=%b",
                din,
                sel,
                expected,
                dout
            );

            match++;

        end

        tr++;

    end

end

    $display("\n======================");
    $display("FINAL REPORT");
    $display("======================");
    $display("Transactions : %0d", tr);
    $display("PASS         : %0d", match);
    $display("FAIL         : %0d", mismatch);
    $display("======================\n");

    #20;
    $finish;
end

demux1x8 uut (
    .clk(clk),
    .rstn(rstn),
    .en(en),
    .sel(sel),
    .din(din),
    .dout(dout)
);

initial begin
    $dumpfile("sim/demux1x8_selfcheck.vcd");
    $dumpvars(0, demux1x8_tb);
end

endmodule
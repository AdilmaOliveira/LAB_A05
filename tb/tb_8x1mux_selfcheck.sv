//Function: The test bench applies with selfcheck
//dout. The waveform mux8x1_tb.vcd can be observed using waveform viewer.
//Test bench file: mux8x1_tb.v

module mux8x1_tb;

// Inputs
logic clk;
logic rstn;
logic en;
logic [7:0] din;
logic [2:0] sel;

// Outputs
logic dout;

// Self-checking
logic expected;

int match;
int mismatch;
int tr;

//variáveis de tempo
time start_time;
time end_time;

// clock generation
always #5 clk = ~clk; // toggle clock for every 5 ticks

task refmod(
    input logic en_i,
    input logic [7:0] din_i,
    input logic [2:0] sel_i,
    output logic exp
);

begin
    exp = 1'b0;

    if(en_i)
        exp = din_i[sel_i];
end

endtask

initial begin

    clk = 0;
    rstn = 0;
    en = 0;
    sel = 0;
    din = 0;

    expected = 0;

    match = 0;
    mismatch = 0;
    tr = 0;

    start_time = $time;

    $display("--------- Test Started ---------");

        // Reset
    #10 rstn = 0;
    #10 rstn = 1;

    en = 1;

    // Teste 1: um bit ativo por vez
    for (int i = 0; i < 8; i++) begin
        sel = i[2:0];
        din = 8'b00000001 << i;

        refmod(en, din, sel, expected);

        @(posedge clk);
        #1;

        if (dout !== expected) begin
            $display("FAIL: sel=%0d din=%b expected=%b got=%b",
                     sel, din, expected, dout);
            mismatch++;
        end else begin
            $display("PASS: sel=%0d din=%b expected=%b got=%b",
                     sel, din, expected, dout);
            match++;
        end

        tr++;
    end

    // Teste 2: entrada toda zerada
    din = 8'b00000000;

    for (int i = 0; i < 8; i++) begin
        sel = i[2:0];

        refmod(en, din, sel, expected);

        @(posedge clk);
        #1;

        if (dout !== expected) begin
            $display("FAIL: sel=%0d din=%b expected=%b got=%b",
                     sel, din, expected, dout);
            mismatch++;
        end else begin
            $display("PASS: sel=%0d din=%b expected=%b got=%b",
                     sel, din, expected, dout);
            match++;
        end

        tr++;
    end
    
    end_time = $time;
    $display("\n======================");
    $display("FINAL REPORT");
    $display("======================");
    $display("Transactions : %0d", tr);
    $display("PASS         : %0d", match);
    $display("FAIL         : %0d", mismatch);
    $display("Execution Time : %0t", end_time - start_time);
    $display("======================\n");

    #20;
    $finish;
 end

    mux8x1 uut (
        .clk(clk),
        .rstn(rstn),
        .en(en),
        .din(din),
        .sel(sel),
        .dout(dout)
    );

    initial begin
        $dumpfile("sim/mux8x1_selfcheck.vcd");
        $dumpvars(0, mux8x1_tb);
    end

endmodule
`timescale 1ns / 1ps

module tb_sram;

reg clk;
reg cs;
reg we;
reg [7:0] addr;
reg [7:0] din;
wire [7:0] dout;

// Instantiate SRAM
sram uut (
    .clk(clk),
    .cs(cs),
    .we(we),
    .addr(addr),
    .din(din),
    .dout(dout)
);

// Clock generation (10ns period)
always #5 clk = ~clk;

// TASK: WRITE
task write;
    input [7:0] a;
    input [7:0] d;
    begin
        @(negedge clk);   // set inputs before posedge
        we = 1;
        addr = a;
        din = d;

        @(posedge clk);   // write happens here
    end
endtask

// TASK: READ
task read;
    input [7:0] a;
    begin
        @(negedge clk);
        we = 0;
        addr = a;

        @(posedge clk);   // read happens here
        #1; // small delay to observe dout
        $display("Time=%0t | Addr=%h | Data=%h", $time, a, dout);
    end
endtask

initial begin
    // Initialize
    clk = 0;
    cs = 1;
    we = 0;
    addr = 0;
    din = 0;

    // ------------------------
    // TEST 1: WRITE & READ
    // ------------------------
    write(8'h05, 8'hAA);
    read(8'h05);   // Expect AA

    // ------------------------
    // TEST 2: OVERWRITE
    // ------------------------
    write(8'h05, 8'h55);
    read(8'h05);   // Expect 55

    // ------------------------
    // TEST 3: MULTIPLE ADDR
    // ------------------------
    write(8'h01, 8'h11);
    write(8'h02, 8'h22);
    read(8'h01);   // Expect 11
    read(8'h02);   // Expect 22

    // ------------------------
    // TEST 4: RANDOM TEST
    // ------------------------
    repeat (5) begin
        write($random % 256, $random);
        read(addr);
    end

    #20;
    $finish;
end

endmodule
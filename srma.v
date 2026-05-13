`timescale 1ns / 1ps

module sram #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 8
)(
    input clk,
    input cs,
    input we,
    input [ADDR_WIDTH-1:0] addr,
    input [DATA_WIDTH-1:0] din,
    output reg [DATA_WIDTH-1:0] dout
);

reg [DATA_WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1];

always @(posedge clk) begin
    if (cs) begin
        if (we)
            memory[addr] <= din;   // WRITE
        else
            dout <= memory[addr];  // READ
    end
end

endmodule
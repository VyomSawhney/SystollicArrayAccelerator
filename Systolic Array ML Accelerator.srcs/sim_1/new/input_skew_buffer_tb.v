`timescale 1ns / 1ps

module input_skew_buffer_tb#(
    parameter ACC_W = 32,
    parameter N = 2
);

    logic clk;
    logic rst_n;
    logic en;
    logic signed [DATA_W-1:0] data_in [N];
    logic signed [DATA_W-1:0] data_out [N];
endmodule

`timescale 1ns / 1ps

module systollic_array #(
    parameter DATA_W = 16,
    parameter ACC_W = 32,
    parameter N = 2
)(
    input logic clk,
    input logic rst_n,
    input logic load_weight,
    input logic en,
    input logic signed [DATA_W-1:0] weight [N][N],
    input logic signed [DATA_W-1:0] A_in [N],
    output logic signed [ACC_W-1:0] out0,
    output logic signed [ACC_W-1:0] out1
    );
    logic signed [ACC_W-1:0] psum00;
    logic signed [DATA_W-1:0] a00;
    logic signed [ACC_W-1:0] psum01;
    logic signed [DATA_W-1:0] a10;
    pe e00(.clk (clk), .rst_n (rst_n), .load_weight (load_weight), .en (en), .a_in (A_in[0]), .weight (weight[0][0]), .psum_in ('0), .psum_out (psum00), .a_out (a00));
    pe e01(.clk (clk), .rst_n (rst_n), .load_weight (load_weight), .en (en), .a_in (a00), .weight (weight[0][1]), .psum_in ('0), .psum_out (psum01));
    pe e10(.clk (clk), .rst_n (rst_n), .load_weight (load_weight), .en (en), .a_in (A_in[1]), .weight (weight[1][0]), .psum_in (psum00), .psum_out (out0), .a_out (a10));
    pe e11(.clk (clk), .rst_n (rst_n), .load_weight (load_weight), .en (en), .a_in (a10), .weight (weight[1][1]), .psum_in (psum01), .psum_out (out1));
endmodule

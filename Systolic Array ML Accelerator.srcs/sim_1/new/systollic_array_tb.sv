`timescale 1ns / 1ps

module systollic_array_tb#(
    parameter DATA_W = 16,
    parameter ACC_W = 32,
    parameter N = 2
);
    logic clk;
    logic rst_n;
    logic load_weight;
    logic en;
    logic signed [DATA_W-1:0] weight [N][N];
    logic signed [DATA_W-1:0] A_in [N];
    logic signed [ACC_W-1:0] out0;
    logic signed [ACC_W-1:0] out1;
    
    systollic_array dut(
        .clk(clk),
        .rst_n(rst_n),
        .load_weight(load_weight),
        .en(en),
        .A_in(A_in),
        .weight(weight),
        .out0(out0),
        .out1(out1)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        rst_n = 0;
        load_weight = 0;
        en = 0;
        weight[0][0] = 1;
        weight[0][1] = 2;
        weight[1][0] = 3;
        weight[1][1] = 4;
        A_in[0] = 0;
        A_in[1] = 0;
    
        @(posedge clk);
        if(out0 == 0 && out1 == 0)begin
            $display("InitReset: Pass");
        end else begin
            $display("InitReset: Fail");
        end
        rst_n = 1;
        load_weight = 1;
        @(posedge clk);
        #1;
        if(dut.e00.weight_reg == 1 && dut.e01.weight_reg == 2 && dut.e10.weight_reg == 3 && dut.e11.weight_reg == 4) begin
            $display("LoadWeights: Pass");
        end else begin
            $display("LoadWeights: Fail");
        end
        load_weight = 0;
        en = 1;
        A_in[0] = 5;
        @(posedge clk);
        #1;
        A_in[0] = 7;
        A_in[1] = 6;
        @(posedge clk);
        #1;
        if(out0 == 23) begin
            $display("E00 Pass");
        end else begin
            $display("E00 Fail");
        end
        A_in[0] = 0;
        A_in[1] = 8;
        @(posedge clk);
        #1;
        if(out0 == 31 && out1 == 34) begin
            $display("E10/01 Pass");
        end else begin
            $display("E10/01 Fail");
        end
        A_in[0] = 0;
        A_in[1] = 0;
        @(posedge clk);
        #1;
        if(out0 == 0 && out1 == 46) begin
            $display("E11/drain Pass");
        end else begin
            $display("E11/drain Fail");
        end
    end
endmodule

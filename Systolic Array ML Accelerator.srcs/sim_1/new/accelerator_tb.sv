`timescale 1ns / 1ps

module accelerator_tb#(
    parameter DATA_W = 16,
    parameter ACC_W = 32,
    parameter N = 2
);
    logic clk;
    logic rst_n;
    logic start;
    logic signed [DATA_W-1:0] weight [N][N];
    logic signed [DATA_W-1:0] A_in [N];
    logic done;
    logic signed [ACC_W-1:0] out [N];
    
    accelerator dut(
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .weight(weight),
        .A_in(A_in),
        .done(done),
        .out(out)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        rst_n = 0;
        start = 0;

        weight[0][0] = 1;
        weight[0][1] = 2;
        weight[1][0] = 3;
        weight[1][1] = 4;
        A_in[0] = 5;
        A_in[1] = 0;
        
        @(posedge clk);
        #1;
        if(out[0] == 0 && out[1] == 0)begin
            $display("InitReset: Pass");
        end else begin
            $display("InitReset: Fail");
        end
        
        @(negedge clk);
        rst_n = 1;
        start = 1;
        @(negedge clk);
        start = 0;
        
        wait(dut.load_en == 1);
        @(posedge clk);
        #1;
        if(dut.array.ROW[0].COL[0].e.weight_reg == 1 &&
           dut.array.ROW[0].COL[1].e.weight_reg == 2 &&
           dut.array.ROW[1].COL[0].e.weight_reg == 3 &&
           dut.array.ROW[1].COL[1].e.weight_reg == 4) begin
            $display("LoadWeights: Pass");
        end else begin
            $display("LoadWeights: Fail");
        end
        
        wait(dut.compute_en == 1);
        @(negedge clk);
        A_in[0] = 5;
        A_in[1] = 6;  
        
        @(posedge clk);
        #1;
        
        @(negedge clk);
        A_in[0] = 7;
        A_in[1] = 8;
        
        @(posedge clk);
        #1;
        if(out[0] == 23) begin
            $display("C00 Pass");
        end else begin
            $display("C00 Fail");
        end
       
        @(negedge clk);
            A_in[0] = 0;
            A_in[1] = 0;
        
        @(posedge clk);
        #1;
        if(out[0] == 31 && out[1] == 34) begin
            $display("C10/C01 Pass");
        end else begin
            $display("C10/C01 Fail");
        end
        
        @(posedge clk);
        #1;
        if(out[0] == 0 && out[1] == 46) begin
            $display("C11/Drain Pass");
        end else begin
            $display("C11/Drain Fail");
        end
        
        wait(done == 1);
        $display("Accelerator Done");

        $finish;
    end
endmodule

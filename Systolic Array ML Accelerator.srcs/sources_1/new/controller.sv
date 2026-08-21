`timescale 1ns / 1ps

module controller#(
    parameter N = 2
)(
    input logic clk,
    input logic rst_n,
    input logic start,
    output logic load_weights,
    output logic skew_en,
    output logic done
);
    logic [2:0] state;
    logic [$clog2(N+1)-1:0] compute;
    logic [$clog2(N+1)-1:0] drain;
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= '0;
            load_weights <= 0;
            skew_en <= 0;
            done <= 0;
            compute <= '0;
            drain <= '0;
        end
        else if(state == 0) begin
            if(start) begin
                state <= 1;
                done <= 0;
            end
            else begin
                load_weights <= 0;
                state <= 0;
                done <= 0;
            end
        end
        else if(state == 1) begin
            load_weights <= 1;
            skew_en <= 0;
            state <= 2;
            done <= 0;
        end
        else if(state == 2) begin
            done <= 0;
            load_weights <= 0;
            skew_en <= 1;
            if(compute == N-1) begin
                compute <= 0;
                state <= 3;
            end else begin
                state <= 2;
                compute <= compute + 1;
            end
        end
        else if(state == 3) begin
            done <= 0;
            load_weights <= 0;
            skew_en <= 1;
            if(drain == N-2) begin
                drain <= 0;
                state <= 4;
            end else begin
                state <= 3;
                drain <= drain + 1;
            end
        end
        else if(state == 4) begin
            skew_en <= 0;
            load_weights <= 0;
            done <= 1;
            state <= 4;
        end
    end
endmodule

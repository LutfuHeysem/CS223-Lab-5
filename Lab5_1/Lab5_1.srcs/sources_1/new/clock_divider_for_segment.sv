`timescale 1ns / 1ps

module clock_divider_segment(
    input logic clk,
    input logic rst,
    output logic slow_clk
    );
    
    logic [16:0] counter;
    
    localparam TARGET = 100_000;
    
    always @(posedge clk or posedge rst)
    begin
        if(rst)begin
            counter <= 0;
            slow_clk <= 0;
        end else begin
            if(counter == TARGET-1)begin
                counter <= 0;  
                slow_clk <= ~slow_clk;
             end else begin
                counter <= counter + 1;
             end
        end
    end
endmodule

`timescale 1ns / 1ps

module eight_bit_gray_tb;

    logic clk;
    logic parallelLoad;
    logic reset;
    logic [7:0] load;
    logic [6:0] segmentDisplay;
    logic [3:0] an;

    eight_bit_gray_upcount uut(
        .clk(clk),
        .parallelLoad(parallelLoad),
        .reset(reset),
        .load(load),
        .segmentDisplay(segmentDisplay),
        .an(an)
    );

    initial begin
        $monitor("Time = %0t, reset = %b, parallelLoad = %b, load = %b, grayCode = %b, 7-segment = %b, an = %b",
        $time, reset, parallelLoad, load, uut.grayCode, segmentDisplay, an);
        
        clk = 0;
        reset = 1;
        parallelLoad = 0;
        load = 8'b00000000;

        #10;
        reset = 0;

        #50;
        load = 8'b10101010;
        parallelLoad = 1;
        #10;
        parallelLoad = 0;

        #100;
        load = 8'b11001100;
        parallelLoad = 1;
        #10;
        parallelLoad = 0;

        #100;
        reset = 1;
        #10;
        reset = 0;

        #200;
        $finish;
    end

    always #5 clk = ~clk;

endmodule

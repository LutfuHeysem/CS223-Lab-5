`timescale 1ns / 1ps

module four_bit_gray_tb;

    logic clk;
    logic parallelLoad;
    logic reset;
    logic [3:0] load;
    logic [6:0] segmentDisplay;
    logic [3:0] an;
    
    four_bit_gray_upcount uut(
        .clk(clk),
        .parallelLoad(parallelLoad),
        .reset(reset),
        .load(load),
        .segmentDisplay(segmentDisplay),
        .an(an)
     );
     
     initial begin
        $monitor("Time = %0t, reset = %b, parallelLoad = %b, load = %b, grayCode = %b, 7-segment = %b, Anode = %b", 
        $time, reset, parallelLoad, load, uut.grayCode, segmentDisplay, an);
        clk = 0;
        reset = 1;
        parallelLoad = 0;          
        load = 4'b0; 

        #10;
        reset = 0;

        #50;

        load = 4'b1010;
        parallelLoad = 1;          
        #10;
        parallelLoad = 0;          

        #50;

        load = 4'b0011;
        parallelLoad = 1;
        #10;
        parallelLoad = 0;

        #50;

        reset = 1;
        #10;
        reset = 0;

        #100;
        $finish;
     end

endmodule

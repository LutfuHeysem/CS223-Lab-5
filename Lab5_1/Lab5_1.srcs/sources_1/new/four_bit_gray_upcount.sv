`timescale 1ns / 1ps

module four_bit_gray_upcount(
    input clk,
    input parallelLoad,
    input reset,
    input logic [3:0] load,
    output logic [6:0] segmentDisplay,
    output logic [3:0] an
    );
    
    logic [3:0] binaryCount;
    logic [3:0] grayCode;

    logic slw_clk;
    clock_divider(.clk(clk), .rst(reset), .slow_clk(slw_clk));
    
    //Count up with reset and load
    always @(posedge slw_clk or posedge reset) begin
        if(reset) begin binaryCount <= 4'b0000; end
        else if(parallelLoad) begin binaryCount <= load; end
        else begin binaryCount <= binaryCount + 1; end
    end
    
    //Conver to gray code
    always @(*) begin
        grayCode <= binaryCount ^ (binaryCount >> 1);
    end
    
    //Display
    always @(*) begin
        case (grayCode)
            4'b0000: segmentDisplay = 7'b1000000;  
            4'b0001: segmentDisplay = 7'b1111001;  
            4'b0010: segmentDisplay = 7'b0100100;  
            4'b0011: segmentDisplay = 7'b0110000;  
            4'b0100: segmentDisplay = 7'b0011001;  
            4'b0101: segmentDisplay = 7'b0010010;  
            4'b0110: segmentDisplay = 7'b0000010;  
            4'b0111: segmentDisplay = 7'b1111000;  
            4'b1000: segmentDisplay = 7'b0000000;  
            4'b1001: segmentDisplay = 7'b0010000;  
            4'b1010: segmentDisplay = 7'b0001000;  
            4'b1011: segmentDisplay = 7'b0000011;  
            4'b1100: segmentDisplay = 7'b1000110;  
            4'b1101: segmentDisplay = 7'b0100001;  
            4'b1110: segmentDisplay = 7'b0000110;  
            4'b1111: segmentDisplay = 7'b0001110;  
            default: segmentDisplay = 7'b1111111;  
        endcase
    end
    
    assign an = 4'b1110; //Activate the rightmost display
    
endmodule

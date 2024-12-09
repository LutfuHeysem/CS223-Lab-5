`timescale 1ns / 1ps

module sixteen_bit_gray_upcount(
    input clk,
    input parallelLoad,
    input reset,
    input logic [15:0] load,
    output logic [6:0] segmentDisplay, 
    output logic [3:0] an              
    );
    
    logic [15:0] binaryCount;
    logic [15:0] grayCode;
    logic [3:0] currentDigit;           
    logic slw_clk;
    logic slw_clk_segment;
    logic [1:0] digitSelect;
    
    clock_divider_segment(.clk(clk), .rst(1'b0), .slow_clk(slw_clk_segment));
    clock_divider(.clk(clk), .rst(1'b0), .slow_clk(slw_clk));
    
    // 16-bit Countup
    always @(posedge slw_clk or posedge parallelLoad or posedge reset) begin
        if (reset) binaryCount <= 16'b0;
        else if (parallelLoad) binaryCount <= load;
        else binaryCount <= binaryCount + 1;
    end
    
    // Convert to Gray code
    always @(*) begin
        grayCode <= binaryCount ^ (binaryCount >> 1);
    end
    
    // cycle through 4 digits
    always @(posedge slw_clk_segment) begin
        digitSelect <= digitSelect + 1;
    end
    
    // Select which digit to display 
    always @(*) begin
        case (digitSelect)
            2'b00: begin
                currentDigit = grayCode[3:0];  
                an = 4'b1110;                  
            end
            2'b01: begin
                currentDigit = grayCode[7:4];  
                an = 4'b1101;               
            end
            2'b10: begin
                currentDigit = grayCode[11:8];
                an = 4'b1011;                
            end
            2'b11: begin
                currentDigit = grayCode[15:12];
                an = 4'b0111;                 
            end
            default: begin
                currentDigit = 4'b0000;
                an = 4'b1111;
            end
        endcase
    end
  
    always @(*) begin
        case (currentDigit)
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
endmodule

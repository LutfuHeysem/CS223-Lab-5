module tb_traffic_light();
    reg clk;
    reg reset;
    reg TA;
    reg TB;           
    wire [2:0] LA_leds;
    wire [2:0] LB_leds;

    traffic_light_system uut (
        .clk(clk),
        .reset(reset),
        .TA(TA),
        .TB(TB),
        .LA_leds(LA_leds),
        .LB_leds(LB_leds)
    );

    always #5 clk = ~clk;

    always @(posedge clk) begin
        $display("Time: %0t | LA LEDs: %b (Red: %0d, Green: %0d, Yellow: %0d) | LB LEDs: %b (Red: %0d, Green: %0d, Yellow: %0d) | TA: %b | TB: %b",
            $time,
            LA_leds,
            LA_leds[2:0] == 3'b111, 
            LA_leds[2:0] == 3'b110, 
            LA_leds[2:0] == 3'b100, 
            LB_leds,
            LB_leds[2:0] == 3'b111, 
            LB_leds[2:0] == 3'b110,   
            LB_leds[2:0] == 3'b100,   
            TA,                       
            TB                        
        );
    end

    initial begin
        clk = 0;
        reset = 1;
        TA = 0;
        TB = 0;
        #20 reset = 0;
        #200;
        TA = 1;
        #100;
        TA = 0;
        TB = 1;
        #300;
        TA = 0;
        TB = 0;
        #200;
        reset = 1;
        #10 reset = 0;
        #200;
        $stop;
    end
endmodule

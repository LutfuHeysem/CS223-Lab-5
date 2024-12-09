`timescale 1ns / 1ps

module traffic_light_system(
    input clk,
    input reset,
    input logic TA,
    input logic TB,
    output logic [2:0] LA_leds,
    output logic [2:0] LB_leds
    );
    
    // State encoding
    typedef enum logic [2:0] {
        S0 = 3'b000,  // LA green, LB red
        S1 = 3'b001,  // LA yellow, LB red
        S2 = 3'b010,  // LA red, LB red (both red)
        S3 = 3'b011,  // LA red, LB yellow
        S4 = 3'b100,  // LA red, LB green
        S5 = 3'b101,  // LA red, LB yellow
        S6 = 3'b110,  // LA red, LB red (both red)
        S7 = 3'b111   // LA yellow, LB red
    } state_t;
    state_t current_state, next_state;
    
    logic slow_clk;
    clock_divider(.clk(clk), .reset(reset), .slow_clk(slow_clk));
    
    // Transition to the next state
    always @(posedge slow_clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end
    
    // Determine the next state
    always @(*) begin
        case(current_state)
            S0: if(TA == 0) next_state = S1;
                else next_state = S0;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S4;
            S4: if(TB == 0) next_state = S5;
                else next_state = S4;
            S5: next_state = S6;
            S6: next_state = S7;
            S7: next_state = S0;
            default: next_state = S0;
        endcase
    end
    
    // Output logic
    always @(*) begin
        case (current_state)
            S0: LA_leds = 3'b110; 
            S1, S7: LA_leds = 3'b100; 
            S2, S3, S4, S5, S6: LA_leds = 3'b111;
            default: LA_leds = 3'b111; 
        endcase
    end
    
    always @(*) begin
        case (current_state)
            S4: LB_leds = 3'b110; 
            S3, S5: LB_leds = 3'b100; 
            S0, S1, S2, S6, S7: LB_leds = 3'b111; 
            default: LB_leds = 3'b111; 
        endcase
    end
    
endmodule

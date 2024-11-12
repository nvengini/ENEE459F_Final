`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2024 03:07:49 PM
// Design Name: 
// Module Name: fp_add_sub
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fp_add_sub(
    input [31:0] a1,
    input [31:0] a2,
    input clk,
    input start,
    input reset,
    output [31:0] result,
    output done
    );
    localparam IDLE = 4'd0,
               DONE = 4'd1,
               SWAP = 4'd2,
               SIGN_1 = 4'd10,
               SHIFT = 4'd3,
               SUM = 4'd4,
               CHECK_SIGN = 4'd5,
               SHIFT_SUM = 4'd6,
               SET_R_S = 4'd7,
               ROUND = 4'd8,
               COMPUTE_SIGN = 4'd9;
               
    reg [4:0] state = IDLE;
    reg [7:0] exp_out; // 8 bit exponent
    reg sign_out;
    reg [22:0] mant_out;
    
    reg swap_flag = 0;
    
    // reg [31:0] input_greater;
    reg sign_greater;
    reg [7:0] exp_greater;
    reg [22:0] mant_greater;
    
    // reg [31:0] input_smaller;
    reg sign_smaller;
    reg [7:0] exp_smaller;
    reg [22:0] mant_smaller;
    
    reg [22:0] mant_shifted;
    reg [22:0] overflow;
    
    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            // set everything to 0
            state <= IDLE;
            //input_greater <= 0;
            // input_smaller <= 0;
            sign_greater <= 0;
            exp_greater <= 0;
            mant_greater <= 0;
            
            
            mant_shifted <= 0;
            overflow <= 0;
            
            swap_flag <=0;
            exp_out <= 0;
            sign_out <=0;
            mant_out <=0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= SWAP;                      
                    end 
                end
                SWAP: begin
                        if (a1[30:23] > a2[30:23] ) begin // exp1 > exp2
                            // input_greater <= a1;
                            sign_greater <= a1[31];
                            exp_greater <= a1[30:23];
                            mant_greater <= a1[22:0];
                            exp_out <= a1[30:23];
                            // input_smaller <= a2;
                            sign_smaller <= a2[31];
                            exp_smaller <= a2[30:23];
                            mant_smaller <= a2[22:0];
                            swap_flag <=0;
                            
                        end else begin                     // exp1 < exp2

                            sign_greater <= a2[31];
                            exp_greater <= a2[30:23];
                            mant_greater <= a2[22:0];
                                                       
                            exp_out <= a2[30:23];
                            
                            sign_smaller <= a1[31];
                            exp_smaller <= a1[30:23];
                            mant_smaller <= a1[22:0];
                            
                            swap_flag <=1;
                        end
                        state <= SIGN_1;  
                end
                SIGN_1: begin 
                    if (sign_greater ^ sign_smaller) begin
                        mant_smaller <= ~mant_smaller + 1'b1;
                    end
                    state <= SHIFT;  
                end
                
                SHIFT: begin
                    mant_shifted <= mant_smaller >> (exp_greater - exp_smaller);
                    overflow <= (mant_smaller & ((1 << (exp_greater - exp_smaller)) - 1)) << (23-(exp_greater - exp_smaller));
                    state <= SUM;
                end
                
                SUM: begin
                
                end
            
            
            endcase
        end
    
    end
endmodule

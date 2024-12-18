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
    output reg done
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
    reg [7:0] exp_intermediate;
    reg sign_out;
    reg [22:0] mant_out;
    
    reg swap_flag = 0;
    
    
    reg sign_greater;
    reg [7:0] exp_greater;              
                                        
                                       
                                        
    reg [23:0] mant_greater;
    
    
    reg sign_smaller;
    reg [7:0] exp_smaller;
    reg [23:0] mant_smaller; // 24 bits long to account for implied 1
    
    reg sign_1_flag;
    
    reg [23:0] mant_shifted;
    reg [23:0] overflow; // overflow from shifting to align mantissas based on exponent difference
    reg g_bit;
    reg r_bit;
    reg sticky_bit;
    
    reg [4:0] shift_counter = 0;
    
    reg [23:0] S; //  SUM register for mantissa
    reg right_shift_flag;
    reg complement_flag;
    
    wire [23:0] sum_prelim;
    wire cout;
    // Uses 24 bit CLA tree structured adder to add mantissas
    CLA_tree_24_bit adder1(.a(mant_greater), .b(mant_shifted), .cin(1'b0), .sum(sum_prelim), .cout(cout));
    
    wire [23:0] s_plus_1;
    wire cout_round;
    
    // Uses 24 bit CLA tree structured adder to add 1 to the sum if necessary when rounding
    CLA_tree_24_bit adder2(.a(S), .b(24'h000001), .cin(1'b0), .sum(s_plus_1), .cout(cout_round));
    
    assign result = {sign_out, exp_out, mant_out};
    
    always @ (posedge clk or posedge reset) begin
        if (reset) begin // RESET logic
            // set everything to 0
            state <= IDLE;
            //input_greater <= 0;
            // input_smaller <= 0;
            sign_greater <= 0;
            exp_greater <= 0;
            mant_greater <= 0;
            sign_smaller <= 0;
            exp_smaller <= 0;
            mant_smaller <= 0;
            
            sign_1_flag <= 0;
            mant_shifted <= 0;
            overflow <= 0;
            S <= 0;
            exp_intermediate <= 0;
            g_bit<=0;
            r_bit<=0;
            sticky_bit<=0;
            
            swap_flag <=0;
            complement_flag <= 0;
            
            shift_counter <= 0;
            right_shift_flag <= 0;
         
            
            exp_out <= 0;
            sign_out <=0;
            mant_out <=0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= SWAP;
                        done <= 0;                      
                    end 
                end
                SWAP: begin // Starts with checks for Infinities, NaNs 
                        if (a1[30:22] == 9'b111111111 || a2[30:22] == 9'b111111111) begin // NaN case
                            {sign_out, exp_out, mant_out} <= 32'b0_11111111_10000000000000000000000;
                            done <= 1;
                            state <= IDLE;
                        end else if (a1 == 32'b0_11111111_00000000000000000000000) begin 
                            if (a2 == 32'b1_11111111_00000000000000000000000) begin // +inf - inf
                                {sign_out, exp_out, mant_out} <= 32'b0_11111111_10000000000000000000000; // NaN
                                done <= 1;
                                state <= IDLE;
                            end else begin
                                {sign_out, exp_out, mant_out} <= 32'b0_11111111_00000000000000000000000; // + infinity
                                done <= 1;
                                state <= IDLE;
                            
                            end
                        
                        end else if (a2 == 32'b0_11111111_00000000000000000000000) begin 
                            if (a1 == 32'b1_11111111_00000000000000000000000) begin // -inf + inf
                                {sign_out, exp_out, mant_out} <= 32'b0_11111111_10000000000000000000000; // NaN
                                done <= 1;
                                state <= IDLE;
                            end else begin
                                {sign_out, exp_out, mant_out} <= 32'b0_11111111_00000000000000000000000; // + infinity
                                done <= 1;
                                state <= IDLE;
                            
                            end
                        end else if (a1 == 32'b1_11111111_00000000000000000000000) begin // a1 = - infinity
                            if (a2 == 32'b0_11111111_00000000000000000000000) begin // -inf + inf
                                {sign_out, exp_out, mant_out} <= 32'b0_11111111_10000000000000000000000; // NaN
                                done <= 1;
                                state <= IDLE;
                            end else begin
                                {sign_out, exp_out, mant_out} <= 32'b1_11111111_00000000000000000000000; // - Infinity
                                done <= 1;
                                state <= IDLE;
                            
                            end
                        
                        end else if (a2 == 32'b1_11111111_00000000000000000000000) begin 
                            if (a1 == 32'b0_11111111_00000000000000000000000) begin // +inf + inf
                                {sign_out, exp_out, mant_out} <= 32'b0_11111111_10000000000000000000000; // NaN
                                done <= 1;
                                state <= IDLE;
                            end else begin
                                {sign_out, exp_out, mant_out} <= 32'b1_11111111_00000000000000000000000; // - Infinity
                                done <= 1;
                                state <= IDLE;
                            
                            end
                        end else if (a1[30:23] > a2[30:23] ) begin // exp1 > exp2
                            // a1 is the larger input
                            sign_greater <= a1[31];
                            exp_greater <= a1[30:23];
                            
                            if (a1[30:23] == 8'b0000_0000) begin
                                mant_greater <= {a1[22:0], 1'b0}; // checks for denormalized number
                            end else begin
                                mant_greater <= {1'b1, a1[22:0]};
                            end
                            exp_intermediate <= a1[30:23];
                            // input_smaller <= a2;
                            sign_smaller <= a2[31];
                            exp_smaller <= a2[30:23];
                            
                            if (a2[30:23] == 8'b0000_0000) begin
                                mant_smaller <= {a2[22:0], 1'b0}; // checks for denormalized number
                            end else begin
                                mant_smaller <= {1'b1, a2[22:0]};
                            end
                            
                            swap_flag <=0;
                            
                        end else begin                     // exp1 =< exp2
                            // a2 is the larger input
                            sign_greater <= a2[31];
                            exp_greater <= a2[30:23];
                            
                            if (a2[30:23] == 8'b0000_0000) begin
                                mant_greater <= {a2[22:0], 1'b0}; // checks for denormalized number
                            end else begin
                                mant_greater <= {1'b1, a2[22:0]};
                            end
                                                       
                            exp_intermediate <= a2[30:23];
                            
                            sign_smaller <= a1[31];
                            exp_smaller <= a1[30:23];
                            
                            if (a2[30:23] == 8'b0000_0000) begin
                                mant_smaller <= {a1[22:0], 1'b0}; // checks for denormalized number
                            end else begin
                                mant_smaller <= {1'b1, a1[22:0]};
                            end
                            
                            
                            swap_flag <=1;
                        end
                        state <= SHIFT; // TODO  change to SHIFT
                end
               
                
                SHIFT: begin                  
                    mant_shifted <= mant_smaller >> (exp_greater - exp_smaller); // Shifts smaller mantissa by the differenc in exponents
                    
                    //populates the overflow register with the shifted out bits
                    overflow <= (mant_smaller & ((1 << (exp_greater - exp_smaller)) - 1)) << (24-(exp_greater - exp_smaller)); 
                    state <= SIGN_1; 
                end
                
                SIGN_1: begin                                   
                    if (sign_greater != sign_smaller) begin
                        // negates the shifted mantissa and overflow if necessary to perform addition of neg and pos or subtraction
                        {mant_shifted, overflow} <= ~{mant_shifted, overflow} + 1'b1;
                        sign_1_flag <=1;
                    end else begin
                        sign_1_flag <=0;
                    end
                    state <= SUM; 
                end
                
                SUM: begin  
                    g_bit <= overflow[23]; // Sets guard bit as the first overflow bit
                    r_bit <= overflow[22]; // Sets round bit to the second overflow bit
                    sticky_bit <= | overflow[21:0]; // sets sticky bit to the logical OR of the rest of the overflow
                    
                    S <= sum_prelim;
                    state <= CHECK_SIGN;
                end
                
                CHECK_SIGN: begin 
                    if ((sign_greater != sign_smaller) && (S[23] == 1) && (cout == 0)) begin
                        S <= ~S + 1'b1; // complements if the previous condition is true per the algorithm
                        complement_flag <= 1;
                        state <= SHIFT_SUM;
                    end else begin
                        complement_flag <= 0;
                        state <= SHIFT_SUM;
                    end
                end
                SHIFT_SUM: begin 
                    if ((sign_greater == sign_smaller) && cout == 1) begin // Right shift
                        {S, r_bit} <= {1'b1, S[23:0]}; // Fill in carry_out bit
                        
                        if (exp_intermediate == 8'b1111_1110) begin // check overflow
                            // Set to infinity
                            sign_out <= sign_greater;
                            mant_out <= 23'b0000_0000_0000_0000_0000_000;
                            exp_out <= 8'b1111_1111;
                            done <= 1;
                            state <= IDLE;
                        end else begin
                            exp_intermediate <= exp_intermediate + 1; 
                        end
                        
                        state <= SET_R_S;
                        right_shift_flag <= 1;
    
                    end else if (S[23] == 1) begin // shift until mantissa is normalized
                        state <= SET_R_S;
                        right_shift_flag <= 0;
                    end else begin
                        right_shift_flag <= 0;
                        
                        if (shift_counter == 0) begin
                            
                            if (exp_intermediate == 8'b0000_0000) begin
                                state <= SET_R_S; // Stop shifting if the exponent is smallest possible
                            end else begin
                                S <= {S[22:0], g_bit}; // if the first shift, shift in the guard bit
                                shift_counter <= shift_counter + 1;
                                exp_intermediate <= exp_intermediate - 1; // update exponent to reflect shifted mantissa
                                state <= SHIFT_SUM;
                            end
                            
                        end else begin
                            if (exp_intermediate == 8'b0000_0000) begin
                                state <= SET_R_S;
                            end else begin
                                S <= S << 1; // for all other shifts, shift in zeros
                                shift_counter <= shift_counter + 1;
                                exp_intermediate <= exp_intermediate - 1; // update exponent to reflect shifted mantissa
                                state <= SHIFT_SUM;
                            end
                        end
                        
                    end
                
                end
                SET_R_S: begin 
                    if (right_shift_flag) begin
                        // r bit has been set in the previous step
                        sticky_bit <= g_bit | r_bit | sticky_bit; // Set sticky bit for right shift case
                        state <= ROUND;
                    end else begin
                        if (shift_counter == 0) begin
                            {r_bit, sticky_bit} <= {g_bit, r_bit | sticky_bit}; // set r and stucky bit for no shift case
                            state <= ROUND;
                        end else if (shift_counter == 1) begin
                            state <= ROUND;
                        end else begin
                            r_bit <= 0; // set r and sticky bits for multiple shift case
                            sticky_bit <= 0;
                            state <= ROUND;
                        end
                    end
                end
                ROUND: begin    // Round to the nearest even number
                    if (S[0] & r_bit | r_bit & sticky_bit) begin
                        if (cout_round) begin
                            S <= {1'b1, s_plus_1[23:1]}; // Add one and shift if there was a carry out
                            
                            if (exp_intermediate == 8'b1111_1110) begin // check overflow
                                // Set to infinity
                                sign_out <= sign_greater;
                                mant_out <= 23'b0000_0000_0000_0000_0000_000;
                                exp_out <= 8'b1111_1111;
                                done <= 1;
                                state <= IDLE;
                            end else begin
                                exp_intermediate <= exp_intermediate + 1; // adjust exponent to reflect mantissa shift
                            end
                            
//                            
                            state <= COMPUTE_SIGN;
                        end else begin
                            S <= s_plus_1; // add one for rounding to nearest even
                            state <= COMPUTE_SIGN;
                        end
                    end else begin
                        state <= COMPUTE_SIGN;
                    end
            
                end
                COMPUTE_SIGN: begin 
                    mant_out <= S[22:0]; // assign intermediate results to output registers
                    exp_out <= exp_intermediate; // assign intermediate exponent to output registers
                    
                    if (sign_greater == sign_smaller) begin // implement rules for result sign from table
                        sign_out <= sign_greater;
                    end else begin
                        if (swap_flag) begin 
                            sign_out <= sign_greater;                 
                        end else begin
                            if (complement_flag) begin
                                sign_out <= sign_smaller;
                            end else begin
                                sign_out <= sign_greater;
                            end
                        end
                    end
                    
                    done <= 1;
                    state <= IDLE;
                end
                
            
                default: state <= IDLE;
            endcase
        end
    
    end
endmodule

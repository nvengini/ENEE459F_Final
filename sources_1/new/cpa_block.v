`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2024 09:19:14 PM
// Design Name: 
// Module Name: csa_block
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


module cpa_block #(parameter N = 40) ( 
    input [N-1:0] a, 
    input [N-1:0] b, 
    output [N-1:0] sum
    );
    
    wire temp_carry [11:0];
    
    // 40 bit design
    four_bit_carry_lookahead_adder f1 (.x(a[3:0]), .y(b[3:0]), .c_in(1'b0), .c_out(temp_carry[0]), .sum(sum[3:0]));
    four_bit_carry_lookahead_adder f2 (.x(a[7:4]), .y(b[7:4]), .c_in(temp_carry[0]), .c_out(temp_carry[1]), .sum(sum[7:4]));
    four_bit_carry_lookahead_adder f3 (.x(a[11:8]), .y(b[11:8]), .c_in(temp_carry[1]), .c_out(temp_carry[2]), .sum(sum[11:8]));
    four_bit_carry_lookahead_adder f4 (.x(a[15:12]), .y(b[15:12]), .c_in(temp_carry[2]), .c_out(temp_carry[3]), .sum(sum[15:12]));
    four_bit_carry_lookahead_adder f5 (.x(a[19:16]), .y(b[19:16]), .c_in(temp_carry[3]), .c_out(temp_carry[4]), .sum(sum[19:16]));
    four_bit_carry_lookahead_adder f6 (.x(a[23:20]), .y(b[23:20]), .c_in(temp_carry[4]), .c_out(temp_carry[5]), .sum(sum[23:20]));
    four_bit_carry_lookahead_adder f7 (.x(a[27:24]), .y(b[27:24]), .c_in(temp_carry[5]), .c_out(temp_carry[6]), .sum(sum[27:24]));
    four_bit_carry_lookahead_adder f8 (.x(a[31:28]), .y(b[31:28]), .c_in(temp_carry[6]), .c_out(temp_carry[7]), .sum(sum[31:28]));
    four_bit_carry_lookahead_adder f9 (.x(a[35:32]), .y(b[35:32]), .c_in(temp_carry[7]), .c_out(temp_carry[8]), .sum(sum[35:32]));
    four_bit_carry_lookahead_adder f10 (.x(a[39:36]), .y(b[39:36]), .c_in(temp_carry[8]), .c_out(temp_carry[9]), .sum(sum[39:36]));
    
    
    
    /* 38 bit design
    three_bit_carry_lookahead t1 (.x(a[2:0]), .y(b[2:0]), .c_in(1'b0), .c_out(temp_carry[0]), .sum(sum[2:0]) );
    three_bit_carry_lookahead t2 (.x(a[5:3]), .y(b[5:3]), .c_in(temp_carry[0]), .c_out(temp_carry[1]), .sum(sum[5:3]) );
    three_bit_carry_lookahead t3 (.x(a[8:6]), .y(b[8:6]), .c_in(temp_carry[1]), .c_out(temp_carry[2]), .sum(sum[8:6]) );
    three_bit_carry_lookahead t4 (.x(a[11:9]), .y(b[11:9]), .c_in(temp_carry[2]), .c_out(temp_carry[3]), .sum(sum[11:9]) );
    three_bit_carry_lookahead t5 (.x(a[14:12]), .y(b[14:12]), .c_in(temp_carry[3]), .c_out(temp_carry[4]), .sum(sum[14:12]) );
    three_bit_carry_lookahead t6 (.x(a[17:15]), .y(b[17:15]), .c_in(temp_carry[4]), .c_out(temp_carry[5]), .sum(sum[17:15]) );
    three_bit_carry_lookahead t7 (.x(a[20:18]), .y(b[20:18]), .c_in(temp_carry[5]), .c_out(temp_carry[6]), .sum(sum[20:18]) );
    three_bit_carry_lookahead t8 (.x(a[23:21]), .y(b[23:21]), .c_in(temp_carry[6]), .c_out(temp_carry[7]), .sum(sum[23:21]) );
    three_bit_carry_lookahead t9 (.x(a[26:24]), .y(b[26:24]), .c_in(temp_carry[7]), .c_out(temp_carry[8]), .sum(sum[26:24]) );
    three_bit_carry_lookahead t10 (.x(a[29:27]), .y(b[29:27]), .c_in(temp_carry[8]), .c_out(temp_carry[9]), .sum(sum[29:27]) );
    
    four_bit_carry_lookahead_adder f1 (.x(a[33:30]), .y(b[33:30]), .c_in(temp_carry[9]), .c_out(temp_carry[10]), .sum(sum[33:30]));
    four_bit_carry_lookahead_adder f2 (.x(a[37:34]), .y(b[37:34]), .c_in(temp_carry[10]), .c_out(), .sum(sum[37:34]));
    */
endmodule
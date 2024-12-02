`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2024 03:31:12 PM
// Design Name: 
// Module Name: three_bit_carry_lookahead
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


module four_bit_carry_lookahead_adder(
    input [3:0] x,
    input [3:0] y,
    input c_in,
    output c_out,
    output [3:0] sum
    );
    
     
    wire p[3:0];
    wire g[3:0];
    wire c1;
    wire c2;
    wire c3;
    
    assign p[0] = x[0] | y[0];
    assign g[0] = x[0] & y[0];
    assign p[1] = x[1] | y[1];
    assign g[1] = x[1] & y[1];
    assign p[2] = x[2] | y[2];
    assign g[2] = x[2] & y[2];
    assign p[3] = x[3] | y[3];
    assign g[3] = x[3] & y[3];
    
    assign c1 = g[0] | p[0]&c_in;
    assign c2 = g[1] | p[1]&g[0] | p[1]&p[0]&c_in;
    assign c3 = g[2] | p[2]&g[1] | p[2]&p[1]&g[0] | p[2]&p[1]&p[0]&c_in;
    assign c_out = g[3] | p[3]&g[2] | p[3]&p[2]&g[1] | p[3]&p[2]&p[1]&g[0] | p[3]&p[2]&p[1]&p[0]&c_in;
    
    assign sum[0] = (x[0]^y[0])^c_in;
    assign sum[1] = (x[1]^y[1])^c1;
    assign sum[2] = (x[2]^y[2])^c2;
    assign sum[3] = (x[3]^y[3])^c3;
endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2024 10:09:38 PM
// Design Name: 
// Module Name: CLA_tree_24_bit
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


module CLA_tree_24_bit(
    input [23:0] a,
    input [23:0] b,
    input cin,
    output cout,
    output [23:0] sum
    );
    
    wire carry_intermediate;
    
    tree_12_adder add1(
        .x(a[11:0]), 
        .y(b[11:0]), 
        .cin(cin), 
        .cout(carry_intermediate), 
        .sum(sum[11:0]));
    
    tree_12_adder add2(
        .x(a[23:12]), 
        .y(b[23:12]), 
        .cin(carry_intermediate), 
        .cout(cout), 
        .sum(sum[23:12]) );
    
endmodule

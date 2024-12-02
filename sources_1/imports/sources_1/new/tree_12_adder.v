`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2024 06:09:33 PM
// Design Name: 
// Module Name: tree_12_adder
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


module tree_12_adder(
    input [11:0]x,
    input [11:0]y,
    input cin,
    output cout,
    output [11:0]sum
    );
    wire carry_intermediate;
    
    tree_6_cla add1(.a(x[5-:6]), .b(y[5-:6]), .sum(sum[5-:6]), .cin(cin), .cout(carry_intermediate));
    
    tree_6_cla add2(.a(x[11-:6]), .b(y[11-:6]), .sum(sum[11-:6]), .cin(carry_intermediate), .cout(cout));
    
endmodule

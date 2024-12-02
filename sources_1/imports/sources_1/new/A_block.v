`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2024 03:58:35 PM
// Design Name: 
// Module Name: A_block
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


module A_block(
    input a,
    input b,
    input cin,
    output sum,
    output g,
    output p
    );
    assign sum = (a ^ b) ^ cin;
    assign p = a | b;
    assign g = a & b;
    
endmodule

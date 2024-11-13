`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2024 04:11:22 PM
// Design Name: 
// Module Name: tree_6_cla
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


module tree_6_cla(
    input [5:0]a,
    input [5:0]b,
    input cin,
    output cout,
    output [5:0]sum
    
    );
    wire w_c0[2:0];
    wire w_c1;
    wire w_c2[1:0];
    wire w_c3;
    wire w_c4[1:0];
    wire w_c5;
    
    wire [5:0] gen_row1; // right side to left side counting up on the first row
    wire [5:0] prop_row1;
    
    wire [2:0] gen_row2; // row 2 of wires, starting at right side then top, right to left
    wire [2:0] prop_row2;
    
    wire gen_row3;
    wire prop_row3;
    
    wire gen_final;
    wire prop_final;
    
    A_block a0(.a(a[0]), .b(b[0]), .cin(w_c0[0]), .sum(sum[0]), .g(gen_row1[0]), .p(prop_row1[0]));
    A_block a1(.a(a[1]), .b(b[1]), .cin(w_c1), .sum(sum[1]), .g(gen_row1[1]), .p(prop_row1[1]));
    
    A_block a2(.a(a[2]), .b(b[2]), .cin(w_c2[0]), .sum(sum[2]), .g(gen_row1[2]), .p(prop_row1[2]));
    A_block a3(.a(a[3]), .b(b[3]), .cin(w_c3), .sum(sum[3]), .g(gen_row1[3]), .p(prop_row1[3]));
    
    A_block a4(.a(a[4]), .b(b[4]), .cin(w_c4[0]), .sum(sum[4]), .g(gen_row1[4]), .p(prop_row1[4]));
    A_block a5(.a(a[5]), .b(b[5]), .cin(w_c5), .sum(sum[5]), .g(gen_row1[5]), .p(prop_row1[5]));
    
    // ci is the output carry
    
    B_block b1(.Gj1k(gen_row1[1]), .Pj1k(prop_row1[1]), .cj1(w_c1), .Gij(gen_row1[0]), .Pij(prop_row1[0]), .ci(w_c0[0]), .Gik(gen_row2[0]), .Pik(prop_row2[0]), .cj(w_c0[1]));
    
    B_block b2(.Gj1k(gen_row1[3]), .Pj1k(prop_row1[3]), .cj1(w_c3), .Gij(gen_row1[2]), .Pij(prop_row1[2]), .ci(w_c2[0]), .Gik(gen_row2[1]), .Pik(prop_row2[1]), .cj(w_c2[1]));
    
    B_block b3(.Gj1k(gen_row1[5]), .Pj1k(prop_row1[5]), .cj1(w_c5), .Gij(gen_row1[4]), .Pij(prop_row1[4]), .ci(w_c4[0]), .Gik(gen_row2[2]), .Pik(prop_row2[2]), .cj(w_c4[1]));
    
    
    // Row 2 of B blocks
    B_block b4(.Gj1k(gen_row2[1]), .Pj1k(prop_row2[1]), .cj1(w_c2[1]), .Gij(gen_row2[0]), .Pij(prop_row2[0]), .ci(w_c0[1]), .Gik(gen_row3), .Pik(prop_row3), .cj(w_c0[2]));
    
    // Row 3   
    B_block b5(.Gj1k(gen_row2[2]), .Pj1k(prop_row2[2]), .cj1(w_c4[1]), .Gij(gen_row3), .Pij(prop_row3), .ci(w_c0[2]), .Gik(gen_final), .Pik(prop_final), .cj(cin));
    
    assign cout = gen_final | (prop_final & cin);
    
endmodule

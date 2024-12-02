`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2024 03:58:35 PM
// Design Name: 
// Module Name: B_block
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


module B_block(
    input Gj1k, Pj1k, // indicate Gj+1,k   Pj+1,k 
    output cj1, //   Cj+1 
    input Gij, Pij,
    output ci,
    output Gik, Pik,
    input cj
    );
    
    assign Pik = Pij & Pj1k;
    assign Gik = Gj1k | Pj1k & Gij;
    
    assign cj1 = Gij | Pij & cj; 
    assign ci = cj;
    
    
endmodule

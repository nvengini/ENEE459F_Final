`timescale 1ns / 1ps

module csa_block #(parameter N = 16)(
    input   [N-1:0] x,
    input   [N-1:0] y,
    input   [N-1:0] z,
    output  [N-1:0] s,
    output  [N-1:0] c
    );
    assign s = x^y^z;
    assign c = (x & y) | (y & z) | (x & z);
endmodule

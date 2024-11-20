`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2024 03:07:49 PM
// Design Name: 
// Module Name: fp_multiplier
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


module fp_multiplier(
        input [31:0] num1,
        input [31:0] num2,
        output [31:0] final_product
    );
  
  
    //mantissa 1
    wire [23:0] a;
    wire [23:0] b;
    //wire [47:0] product;
    assign a = {1'b1, num1[22:0]};
    assign b = {1'b1, num2[22:0]};
  
  
  
////////////////////////////// mantissa multiplication ////////////////////////////
    wire [23:0] a_and_b0 = a & {24{b[0]}};
    wire [23:0] a_and_b1 = a & {24{b[1]}};
    wire [23:0] a_and_b2 = a & {24{b[2]}};
    wire [23:0] a_and_b3 = a & {24{b[3]}};
    wire [23:0] a_and_b4 = a & {24{b[4]}};
    wire [23:0] a_and_b5 = a & {24{b[5]}};
    wire [23:0] a_and_b6 = a & {24{b[6]}};
    wire [23:0] a_and_b7 = a & {24{b[7]}};
    wire [23:0] a_and_b8 = a & {24{b[8]}};
    wire [23:0] a_and_b9 = a & {24{b[9]}};
    wire [23:0] a_and_b10 = a & {24{b[10]}};
    wire [23:0] a_and_b11 = a & {24{b[11]}};
    wire [23:0] a_and_b12 = a & {24{b[12]}};
    wire [23:0] a_and_b13 = a & {24{b[13]}};
    wire [23:0] a_and_b14 = a & {24{b[14]}};
    wire [23:0] a_and_b15 = a & {24{b[15]}};
    wire [23:0] a_and_b16 = a & {24{b[16]}};
    wire [23:0] a_and_b17 = a & {24{b[17]}};
    wire [23:0] a_and_b18 = a & {24{b[18]}};
    wire [23:0] a_and_b19 = a & {24{b[19]}};
    wire [23:0] a_and_b20 = a & {24{b[20]}};
    wire [23:0] a_and_b21 = a & {24{b[21]}};
    wire [23:0] a_and_b22 = a & {24{b[22]}};
    wire [23:0] a_and_b23 = a & {24{b[23]}};
    
    wire [23:0] s00;
    wire [23:0] s01;
    wire [23:0] s02;
    wire [23:0] s03;
    wire [23:0] s04;
    wire [23:0] s05;
    wire [23:0] s06;
    wire [23:0] s07;
    wire [23:0] s10;
    wire [25:0] s11;
    wire [23:0] s12;
    wire [25:0] s13;
    wire [23:0] s14;
    wire [25:0] s20;
    wire [26:0] s21;
    wire [25:0] s22;
    wire [27:0] s30;
    wire [28:0] s31;
    wire [32:0] s40;
    wire [23:0] s41;
    wire [40:0] s50;
    wire [39:0] s60;
    
    
    
    wire [23:0] c00;
    wire [23:0] c01;
    wire [23:0] c02;
    wire [23:0] c03;
    wire [23:0] c04;
    wire [23:0] c05;
    wire [23:0] c06;
    wire [23:0] c07;
    wire [23:0] c10;
    wire [25:0] c11;
    wire [23:0] c12;
    wire [25:0] c13;
    wire [23:0] c14;
    wire [25:0] c20;
    wire [26:0] c21;
    wire [25:0] c22;
    wire [27:0] c30;
    wire [28:0] c31;
    wire [32:0] c40;
    wire [23:0] c41;
    wire [40:0] c50;
    wire [39:0] c60;
    
    // first level csa
    csa_block #(24) csa00 ( .x({1'b0, a_and_b0[23:1]}), .y(a_and_b1), .z({a_and_b2[22:0], 1'b0}), .s(s00), .c(c00));
    wire [23:0] s00p = {a_and_b2[23], s00[23:1]}; //remove 2 for product bit.
    
    csa_block #(24) csa01 ( .x({1'b0, a_and_b3[23:1]}), .y(a_and_b4), .z({a_and_b5[22:0], 1'b0}), .s(s01), .c(c01));
    wire [25:0] s01p = {a_and_b5[23], s01, a_and_b3[0]};
    
    csa_block #(24) csa02 ( .x({1'b0, a_and_b6[23:1]}), .y(a_and_b7), .z({a_and_b8[22:0], 1'b0}), .s(s02), .c(c02));
    wire [25:0] s02p = {a_and_b8[23], s02, a_and_b5[0]};
    
    csa_block #(24) csa03 ( .x({1'b0, a_and_b9[23:1]}), .y(a_and_b10), .z({a_and_b11[22:0], 1'b0}), .s(s03), .c(c03));
    wire [25:0] s03p = {a_and_b11[23], s03, a_and_b9[0]};
    
    csa_block #(24) csa04 ( .x({1'b0, a_and_b12[23:1]}), .y(a_and_b13), .z({a_and_b14[22:0], 1'b0}), .s(s04), .c(c04));
    wire [25:0] s04p = {a_and_b14[23], s04, a_and_b12[0]};
    
    csa_block #(24) csa05 ( .x({1'b0, a_and_b15[23:1]}), .y(a_and_b16), .z({a_and_b17[22:0], 1'b0}), .s(s05), .c(c05));
    wire [25:0] s05p = {a_and_b17[23], s05, a_and_b15[0]};
    
    csa_block #(24) csa06 ( .x({1'b0, a_and_b18[23:1]}), .y(a_and_b19), .z({a_and_b20[22:0], 1'b0}), .s(s06), .c(c06));
    wire [25:0] s06p = {a_and_b20[23], s06, a_and_b18[0]};
    
    csa_block #(24) csa07 ( .x({1'b0, a_and_b21[23:1]}), .y(a_and_b22), .z({a_and_b23[22:0], 1'b0}), .s(s07), .c(c07));
    wire [25:0] s07p = {a_and_b23[23], s07, a_and_b21[0]};


    //second level
    csa_block #(24) csa10 ( .x(s00p), .y(c00), .z({s01p[22:0], 1'b0}), .s(s10), .c(c10));
    wire [25:0] s10p = {s01p[25:23], s10[23:1]}; //drop last bit for product bit
    
    csa_block #(26) csa11 ( .x({3'b000, c01[23:1]}), .y(s02p), .z({c02, 2'b00}), .s(s11), .c(c11) );
    wire [26:0] s11p = {s11, c01[0]};
    
    csa_block #(24) csa12 ( .x(s03p[25:2]), .y(c03), .z({s04p[22:0], 1'b0}), .s(s12), .c(c12) );
    wire [28:0] s12p = {s04p[25:23], s12, s03p[1:0]};
    
    csa_block #(26) csa13 ( .x({3'b000, c04[23:1]}), .y(s05p), .z({c05, 2'b00}), .s(s13), .c(c13) );
    wire [26:0] s13p = {s13, c04[0]};
    
    csa_block #(24) csa14 ( .x(s06p[25:2]), .y(c06), .z({s07p[22:0], 1'b0}), .s(s14), .c(c14) );
    wire [28:0] s14p = {s07p[25:23], s14, s06p[1:0]};
    
    
    
    //third level
    csa_block #(26) csa20 ( .x(s10p), .y({2'b00, c10}), .z({s11p[23:0], 2'b00}), .s(s20), .c(c20) );
    wire [27:0] s20p = {s11p[26:24], s20[25:1]}; //drop top bit for product bit
    
    csa_block #(27) csa21 ( .x({3'b000, c11[25:2]}), .y({s12p[26:0]}), .z({c12, 3'b000}), .s(s21), .c(c21) );
    wire [30:0] s21p = {s12p[28:27], s21, c11[1:0]};
    
    csa_block #(26) csa22 ( .x({1'b0, s13p[26:2]}), .y(c13), .z({s14p[23:0], 2'b00}), .s(s22), .c(c22) );
    wire [32:0] s22p = {s14p[28:24], s22, s13p[1:0] };
        
    
    //fourth level
    csa_block #(28) csa30 ( .x(s20p), .y({2'b00, c20}), .z({s21p[24:0], 3'b000}), .s(s30), .c(c30) );
    wire [32:0] s30p = {s21p[30:25], s30[27:1]}; //last bit to product
    
    csa_block #(29) csa31 ( .x({6'b000000, c21[26:4]}), .y(s22p[28:0]), .z({c22, 3'b000}), .s(s31), .c(c31) );
    wire [36:0] s31p = {s22p[32:29], s31, c21[3:0]};
    
    
    //fifth level
    csa_block #(33) csa40 ( .x(s30p), .y({5'b00000, c30}), .z({s31p[27:0], 5'b00000}), .s(s40), .c(c40) );
    wire [40:0] s40p = {s31p[36:28], s40[32:1]}; //last bit removed
    
    csa_block #(24) csa41 ( .x({1'b0, c31[28:6]}), .y({c07[21:0], 2'b00}), .z(c14), .s(s41), .c(c41) );
    wire [31:0] s41p = {c07[23:22], s41, c31[5:0]};



    //sixth level
    csa_block #(41) csa50 ( .x(s40p), .y({8'b00000000, c40}), .z({s41p, 9'b000000000}), .s(s50), .c(c50) );
    wire [39:0] s50p = s50[40:1]; //removed prod bit

    
    //seventh level
    csa_block #(40) csa60 ( .x(s50p), .y(c50[39:0]), .z({1'b0, c41, 15'b000000000000000}), .s(s60), .c(c60) );
    wire [39:0] s60p = {c50[40], s60[39:1]}; //removed prod bit


    // final 40 bit cpa
    
    wire [47:0] init_prod;
    cpa_block cpa_final ( .a(s60p), .b(c60), .sum(init_prod[47:8]) );
    assign init_prod[0] = a_and_b0[0];
    assign init_prod[1] = s00[0];
    assign init_prod[2] = s10[0];
    assign init_prod[3] = s20[0];
    assign init_prod[4] = s30[0];
    assign init_prod[5] = s40[0];
    assign init_prod[6] = s50[0];
    assign init_prod[7] = s60[0];
    
    wire [45:0] init_mant = init_prod[45:0];
    wire check_bit = init_mant[45];
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     
    //turn into 8 bit adder!!!
    wire [7:0] final_exp;// = num1[30:23] + num2[30:23] - 8'b01111111;
    
    
    wire final_signed = num1[31] ^ num2[31];
    
    assign final_exp = num1[30:23] + num2[30:23] - {7'b0111111, ~check_bit};
    
    wire [45:0] final_mant = (init_mant << ~(check_bit)); //shifts by 0 if nothing

    assign final_product[31] = final_signed;
    assign final_product[30:23] = final_exp;
    assign final_product[22:0] = final_mant[45:23];

    //rounding using the 38 bit cpa block.
    //wire [37:0] rounding;
    //assign rounding = {22'b0, product[22], 15'b0}; //put the rounding bit at the proper location
    //wire [37:0] rounded_product;
    
    
    //cpa_block round_product ( .a(product[45:8]), .b(rounding), .sum(rounded_product));
    //assign final_product[22:0] = rounded_product[37:15];
    
    
endmodule

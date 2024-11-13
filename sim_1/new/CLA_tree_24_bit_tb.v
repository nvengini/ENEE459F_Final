`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2024 10:16:12 PM
// Design Name: 
// Module Name: CLA_tree_24_bit_tb
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


module CLA_tree_24_bit_tb(

    );
    
    reg cin;
    reg [23:0]a;
    reg [23:0]b;
    
    //Outputs
    wire [23:0]sum;
    wire cout;
    CLA_tree_24_bit UUT(
        .cin(cin),
        .a(a),
        .b(b),
        .cout(cout),
        .sum(sum)
    );
    initial begin
        cin = 1'b0;
        a = 24'b000000000000_000000000000;
        b = 24'b000000000000_000000000000;
        
        $monitor($time,, "Inputs: X=%d, Y=%d, C_in=%d... Expected Sum: %d, Outputs: SUM=%d, C_out = %d", a,b,cin, (a+b+cin) % 24'hFFFFFF,  sum, cout);
        #10
        a = 'd260;
        b = 'd145;
        
        #10
        a = 'd4095;
        b = 'd4;
        
        #10;
        cin = 1;
        a = 'd15000000;
        b = 'd2478;
        
        #10;
        a = 'd9999999;
        b = 'd4045;
        
        #10;
        cin = 0;
        a = 'd1000;
        b = 'd16777200;
        
    end
endmodule

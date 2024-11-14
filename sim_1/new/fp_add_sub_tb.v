`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2024 08:27:53 PM
// Design Name: 
// Module Name: fp_add_sub_tb
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


module fp_add_sub_tb(

    );
    reg [31:0]in1;
    reg [31:0]in2;
    reg clk = 0;
    reg start;
    reg reset;
    wire [31:0] result;
    wire done;
    
    fp_add_sub add(.a1(in1), .a2(in2), .clk(clk), .start(start), .reset(reset), .result(result), .done(done));
    
    initial begin
        forever #5 clk = ~clk;
    end
    
    initial begin
        in1 = 0;
        in2 = 0;
        start = 0;
        reset = 0;
        #10
        reset = 1;
        #10
        reset = 0;
        #10
        
        in1 = 32'b0_01111111_11000000000000000000000;
        in2 = 32'b0_10000000_10100000000000000000000;
        start=1;
        #10;
        start=0;
        wait(done);
        #20;
        reset = 1;
        #10;
        reset = 0;
        #10
        
        
        in1 = 32'b0_10000011_10010100000000000000000;
        in2 = 32'b0_10000001_11000010000000000000000;
        start=1;
        #10;
        start=0;
        wait(done);
        #20;
        reset = 1;
        #10;
        reset = 0;
        #10
        
        
        in1 = 32'b0_10000000_10100000000000000000000;
        in2 = 32'b1_01111111_11000000000000000000000;
        start=1;
        #10;
        start=0;
        wait(done);
        #20;
        reset = 1;
        #10;
        reset = 0;
        #10
        
        in1 = 32'b1_10000000_10100000000000000000000;
        in2 = 32'b0_01111111_11000000000000000000000;
        start=1;
        #10;
        start=0;
        wait(done);
        #20;
        reset = 1;
        #10;
        reset = 0;
        #10
        
        
        in1 = 32'b0_10000111_11001000010011001100110; // 456.29998779296875
        in2 = 32'b0_10000010_10000001111010111000011; // 12.06000041961669921875
        // Expected result (after rounding): 468.3599853515625
        // 0_10000111_11010100010111000010100
        start=1;
        #10;
        start=0;
        wait(done);
        #20;
        reset = 1;
        #10;
        reset = 0;
        #10;
        
        in1 = 32'b1_10000111_11001000010011001100110; // -456.29998779296875
        in2 = 32'b0_10000010_10000001111010111000011; // 12.06000041961669921875
        // Expected result (after rounding): -444.239990234375
        // 11000011110111100001111010111000
        start=1;
        #10;
        start=0;
        wait(done);
        #20;
        reset = 1;
        #10;
        reset = 0;
        #10
        
        in1 = 32'b0_01110101_01000111101011000011010; // 0.00124997203238308429718017578125
        in2 = 32'b1_01110001_10011110110001100100101; // -0.0000988899628282524645328521728515625
        // Expected result (after rounding): 
        // 00111010100101101101111111101000 --> 0.001151082105934619903564453125
        start=1;
        #10;
        start=0;
        wait(done);
        #20;
        reset = 1;
        #10;
        reset = 0;
        #10
        
        
        $finish;
    end
endmodule

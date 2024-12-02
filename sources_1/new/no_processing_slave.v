`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2024 12:48:01 PM
// Design Name: 
// Module Name: no_processing_slave
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


module no_processing_slave(
    input CLK,
    input RST,
        
    inout i2c_sda,
    inout i2c_scl,
    
    output CS,
    output SDIN,
    output SCLK,
    output DC,
    output RES,
    output VBAT,
    output VDD,
    output FIN,
    output [7:0] slave_data_output
    );
    wire [31:0] slave_data_out;
    
     assign slave_data_output = slave_data_out[7:0];
    
    i2c_slave_controller slave (
        .i2c_sda(i2c_sda), 
        .i2c_scl(i2c_scl),
        .dataout(slave_data_out)        
    );
    
    
    
    PmodOLEDCtrl oled(.CLK(CLK), 
                        .RST(RST), 
                        .EN(1'b1), 
                        .data_in(slave_data_out), 
                        .CS(CS), 
                        .SDIN(SDIN), 
                        .SCLK(SCLK), 
                        .DC(DC), 
                        .RES(RES), 
                        .VBAT(VBAT), 
                        .VDD(VDD), 
                        .FIN(FIN)
            );
endmodule

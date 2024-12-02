`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2024 09:20:40 PM
// Design Name: 
// Module Name: slave_top
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


module slave_top(
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
    output [7:0] slave_data_output,
    output [2:0] state_out,
    output [1:0] cnt,
    output rx_done_out,
    output start_out,
    output [2:0] slave_state_out
    );
    
    wire rx_done;
    wire [31:0] slave_data_out;
    
    wire [31:0] OLED_data;
    wire [31:0] OLED_opcode_disp;
    assign rx_done_out = rx_done;
    assign slave_data_output = slave_data_out[7:0];
    
    slave_processing_fsm_top fsm (
        .done(rx_done),
        .slave_data_rx(slave_data_out),
        .clk(CLK),
        .OLED_data(OLED_data),
        .OLED_opcode_disp(OLED_opcode_disp),
        .state_out(state_out),
        .cnt(cnt)    
    );
    
    i2c_slave_controller slave (
        .i2c_sda(i2c_sda), 
        .i2c_scl(i2c_scl),
        .dataout(slave_data_out),
        .rx_done(rx_done),
        .start_out(start_out),
        .state_out(slave_state_out)      
    );
    
    
    
    PmodOLEDCtrl oled(.CLK(CLK), 
                        .RST(RST), 
                        .EN(1'b1), 
                        .data_in1(OLED_opcode_disp),
                        .data_in2(OLED_data), 
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

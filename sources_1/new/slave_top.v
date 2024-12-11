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
    input CLK, // connected to W5 100 MHz clock
    input RST,
        
    inout i2c_sda, // I2C lines (also needs a common ground connection to work)
    inout i2c_scl,
    
    output CS, // OLED outputs for SPI communication
    output SDIN,
    output SCLK,
    output DC,
    output RES,
    output VBAT,
    output VDD,
    output FIN,
    output [7:0] slave_data_output, // All of the following are debugging outputs
    output [2:0] state_out, 
    output [1:0] cnt,
    output rx_done_out,
    output start_out,
    output [2:0] slave_state_out
    );
    
    wire rx_done;
    wire [31:0] slave_data_out;
    
    wire [31:0] OLED_result;		
	wire [31:0] OLED_A;				
	wire [31:0] OLED_B;				
    wire [31:0] OLED_opcode_disp;
    assign rx_done_out = rx_done;
    assign slave_data_output = slave_data_out[7:0];
    
    slave_processing_fsm_top fsm (
        .done(rx_done),
        .slave_data_rx(slave_data_out),
        .clk(CLK),
        .OLED_result(OLED_result),	// State machine data outputs (opcode, operands, result)
		.OLED_A(OLED_A),			// sent to OLED display
		.OLED_B(OLED_B),			
        .OLED_opcode_disp(OLED_opcode_disp),
        .state_out(state_out), // Debug output to Pmod
        .cnt(cnt)               // Debug output to Pmod
    );
    
    i2c_slave_controller slave (
        .i2c_sda(i2c_sda), 
        .i2c_scl(i2c_scl),
        .dataout(slave_data_out), // data sent to state machine to be assigned to OLED inputs
        .rx_done(rx_done), // sent to state machine to indicate how many i2c receives have occurred
        .start_out(start_out), // debug output to Pmod
        .state_out(slave_state_out) // debug output to Pmod     
    );
    
    
    
    PmodOLEDCtrl oled(.CLK(CLK), 
                        .RST(RST), 
                        .EN(1'b1), 
                        .data_in1(OLED_opcode_disp),	// Opcode input
                        .data_in2(OLED_A), 			// operand 1 input
						.data_in3(OLED_B),			// operand 2 input
						.data_in4(OLED_result),			// result input
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

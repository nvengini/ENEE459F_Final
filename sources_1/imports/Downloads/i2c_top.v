`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2024 03:59:33 PM
// Design Name: 
// Module Name: i2c_top
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


module i2c_top( 
    output wire [7:0] led_output,
    input en,
    input rst,
    input clk,
    input [7:0] data_in_input,
    output sda_out,
    output scl_out,
    output rdy_out,
    output [2:0] state_out,
//    output rst_out,
    output en_out,
    output [7:0] slave_data_output
    );
    //,
    //inout sda_sl_out,
    //inout scl_sl_out,
    //inout sda_m_out,
    //inout scl_m_out
    //);
    
    assign sda_out = i2c_sda;
    assign scl_out = i2c_scl;
    
    // Inputs
	//reg adj_clk;
	//reg rst;
	reg [6:0] addr = 7'b0101010;
	//wire [7:0] data_in = 8'b00011101;
	//reg enable;
	reg rw = 0;
    //assign data_in = data_in_input;
    
	// Outputs
	wire [7:0] data_out;
    wire ready;
    wire [7:0] slave_data_out;
    assign slave_data_output = slave_data_out;
	
	// Bidirs
	wire i2c_sda;
	wire i2c_scl;
	
	// assign outputs
	assign led_output = slave_data_out;//8'b01010101;//slave.dataout;
	//assign sda_sl_out = slave.i2c_sda; 
	//assign scl_sl_out = slave.i2c_scl;
	//assign sda_m_out = master.i2c_sda;
	//assign sda_m_out = master.i2c_scl;
    assign rst_out = rst;
    assign en_out = en;
    assign rdy_out = master.ready;
    
	// Instantiate the Unit Under Test (UUT)
	i2c_master_controller master (
		.clk(clk), 
		.rst(rst), 
		.addr(addr), 
		.data_in(data_in_input), 
		.enable(en), 
		.rw(rw), 
		.data_out(data_out), 
		.ready(ready), 
		.i2c_sda(i2c_sda), 
		.i2c_scl(i2c_scl)
	);
	
		
	i2c_slave_controller slave (
    .i2c_sda(i2c_sda), 
    .i2c_scl(i2c_scl),
    .dataout(slave_data_out),
    .state_out(state_out)
    );
    
    //start the test:
    
    
endmodule

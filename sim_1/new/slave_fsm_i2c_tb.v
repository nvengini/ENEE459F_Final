`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2024 01:53:51 PM
// Design Name: 
// Module Name: slave_fsm_i2c_tb
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


module slave_fsm_i2c_tb(

    );
    
    	// Inputs
	reg clk;
	reg rst;
	reg [6:0] addr = 0;
	reg [31:0] data_in = 0;
	reg enable = 0;
	reg rw = 0;
    // reg x = 1'bz;
	// Outputs
	wire [7:0] data_out;
	wire ready;
	wire rx_done;
	wire [2:0] state_out;
	wire [1:0] count;
    
    wire [31:0] slave_data_out;
    wire [31:0] OLED_opcode_disp;
    wire [31:0] OLED_data;
    wire [2:0] state_out_fsm;
	// Bidirs
	wire i2c_sda;
	wire i2c_scl;

	// Instantiate the Unit Under Test (UUT)
	i2c_master_controller master (
		.clk(clk), 
		.rst(rst), 
		.addr(addr), 
		.data_in(data_in), 
		.enable(enable), 
		.rw(rw), 
		.data_out(data_out), 
		.ready(ready), 
		.i2c_sda(i2c_sda), 
		.i2c_scl(i2c_scl)
	);
	
		
	i2c_slave_controller slave (
    .i2c_sda(i2c_sda), 
    .i2c_scl(i2c_scl),
    // .reset(rst),
    .state_out(state_out),
    .dataout(slave_data_out),
    .rx_done(rx_done)
    );
    
    slave_processing_fsm_top UUT(
        .done(rx_done), 
        .slave_data_rx(slave_data_out), 
        .cnt(count), 
        .clk(clk),
        .OLED_data(OLED_data),
        .OLED_opcode_disp(OLED_opcode_disp),
        .state_out(state_out_fsm)
        );

	
	initial begin
		clk = 0;
		forever begin
			clk = #1 ~clk;
		end		
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rst = 0;		
		addr = 7'b0101010;
		data_in = 32'h12345678;
		rw = 0;	
		enable = 1;
		#40;
		enable = 0;
		#500
		
		#40
		data_in = 32'habcdef1;
		#40
		enable = 1;
		#20
		enable = 0;
		#500
		
		#40
		data_in = 32'ha0b0c0d1;
		#40
		enable = 1;
		#20
		enable = 0;
		#500
		
		
		
		// Opcode 2
		data_in = 32'h0000_0001; // opcode
		rw = 0;	
		enable = 1;
		#40;
		enable = 0;
		#500
		
		#40
		data_in = 32'habcdef1;
		#40
		enable = 1;
		#20
		enable = 0;
		#500
		
		#40
		data_in = 32'ha0b0c0d1;
		#40
		enable = 1;
		#20
		enable = 0;
		#500
		
		
		
		#500
		$finish;
		
	end 
endmodule

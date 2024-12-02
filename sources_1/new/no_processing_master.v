`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2024 12:48:01 PM
// Design Name: 
// Module Name: no_processing_master
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


module no_processing_master(
    input clk_100MHz,       // basys 3 FPGA clock signal
    input reset,            // btnR    
    input rx,               // USB-RS232 Rx
    input btn,              // btnL (read and write FIFO operation)
    output tx,              // USB-RS232 Tx
    inout i2c_sda,
	inout wire i2c_scl
    );
    
    
    reg [6:0] addr = 7'b0101010;
    reg rw = 0;
    wire ready;
    wire rx_full, rx_empty, btn_tick;
    wire [7:0] rec_data, rec_data1;
    
      
    // Complete UART Core
    uart_top UART_UNIT
        (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .read_uart(btn_tick),
            .write_uart(btn_tick),
            .rx(rx),
            .write_data(rec_data), // TX back to PC
            .rx_full(rx_full),
            .rx_empty(rx_empty),
            .read_data(rec_data), // RX from PC
            .tx(tx)
        );
    
    // Button Debouncer
    debounce_explicit BUTTON_DEBOUNCER
        (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .btn(btn),         
            .db_level(),  
            .db_tick(btn_tick)
        );
        
    i2c_master_controller master (
		.clk(clk_100MHz), 
		.rst(reset), 
		.addr(addr), 
		.data_in(rec_data), // Change to UART output
		.enable(btn), // controlled by state machine
		.rw(rw), 
		.data_out(data_out), // unused
		.ready(ready), // map to LED?
		.i2c_sda(i2c_sda), // outputs to other board
		.i2c_scl(i2c_scl) // output to other board
	);
	
	    
    
endmodule

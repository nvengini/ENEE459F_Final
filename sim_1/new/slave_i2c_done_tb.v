`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2024 02:07:28 PM
// Design Name: 
// Module Name: slave_i2c_done_tb
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


module slave_i2c_done_tb(

    );
    reg clk = 0;
    initial begin
        forever #5 clk = ~clk;
    end
    reg done = 0;
    reg [7:0] slave_data_rx = 0;
    wire [1:0] count;
    slave_processing_fsm_top UUT(.done(done), .slave_data_rx(slave_data_rx), .cnt(count), .clk(clk));
    
    
    initial begin
    #20
    slave_data_rx = 8'b0000_0000;
    #5
    done = 1;
    #5
    done = 0;
    #20
    
    slave_data_rx = 8'd4;
    #5
    done = 1;
    #5
    done = 0;
    #20
    
    slave_data_rx = 8'd6;
    #5
    done = 1;
    #5
    done = 0;
    #30;
  
    // TRANSMIT 2
    #10
    slave_data_rx = 8'b0000_0001;
    #5
    done = 1;
    #5
    done = 0;
    #20
    
    slave_data_rx = 8'd4;
    #5
    done = 1;
    #5
    done = 0;
    #20
    
    slave_data_rx = 8'd6;
    #5
    done = 1;
    #5
    done = 0;
    #30;
    
    // TRANSMIT 3
    #10
    slave_data_rx = 8'b0000_0010;
    #5
    done = 1;
    #5
    done = 0;
    #20
    
    slave_data_rx = 8'd4;
    #5
    done = 1;
    #5
    done = 0;
    #20
    
    slave_data_rx = 8'd6;
    #5
    done = 1;
    #5
    done = 0;
    #30;
    
    
    // TRANSMIT 4
    #10
    slave_data_rx = 8'b0000_0011;
    #5
    done = 1;
    #5
    done = 0;
    #20
    
    slave_data_rx = 8'd4;
    #5
    done = 1;
    #5
    done = 0;
    #20
    
    slave_data_rx = 8'd6;
    #5
    done = 1;
    #5
    done = 0;
    #30;
    
    
    
    end
    
    
endmodule

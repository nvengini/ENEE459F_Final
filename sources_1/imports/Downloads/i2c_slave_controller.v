`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 03:08:42 PM
// Design Name: 
// Module Name: i2c_slave_controller
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


module i2c_slave_controller(
    inout i2c_sda,
    inout i2c_scl,
    output [31:0] dataout,
    output [3:0] state_out,
    output rx_done
    );
    
    localparam ADDRESS = 7'b0101010; // Slave Address
    // State machine parameters
    localparam IDLE = 0;
    localparam READ_ADDR = 1;
    localparam SEND_ACK = 2;
    localparam READ_DATA = 3;
    localparam SEND_ACK2 = 4;

    reg start = 1'b0;//0
    
    //wire start;
    //reg start1 = 1'b0;
    //reg start2 = 1'b0;
    //assign start = start1 | start2;
        
    reg [4:0] counter = 5'b00111;
    reg [2:0] state = IDLE;
    reg [7:0] rx_addr = 8'b00000000;
    reg [31:0] data_in = 32'b00000000;
    
    
    reg write_enable; //0
    reg sda_out;
    assign i2c_sda = (write_enable == 1) ? sda_out : 1'bz;
    
    reg [31:0] data_out_intermediate;
    assign dataout = data_out_intermediate;
   
    reg rx_done_flag = 0;
    assign rx_done = rx_done_flag;
   
    assign state_out = state;
    
    always @(negedge i2c_sda) begin
        if ((start == 0) && (i2c_scl == 1)) begin
            start <= 1;
        end else if (state == IDLE) begin
            start <= 0;
        end
     end    
     
     always @(negedge i2c_scl) begin
        
        case(state)
            IDLE: begin
                write_enable <= 0;
            end
        
            READ_ADDR: begin
                write_enable <= 0;
            end
            
            SEND_ACK: begin
                write_enable <= 1;
                sda_out <= 0;
            end
                
            READ_DATA: begin
                write_enable <= 0;
            end
            
            SEND_ACK2: begin
                write_enable <= 1;
                sda_out <= 0;
            end    
            
        endcase
    end  
            
    always @(posedge i2c_scl) begin

        case(state)
        
            IDLE: begin
                if (start == 1) begin
                    state <= READ_ADDR;
                    rx_addr[7] <= i2c_sda; // NSV changed
                end
                counter <= 5'b00110;
                //waiting for start condition
            end
            
            READ_ADDR: begin
                rx_done_flag <= 0;
                rx_addr[counter] = i2c_sda;
                if (counter == 0) begin
                    if (rx_addr[7:1] == ADDRESS) begin
                        rx_addr <= 8'b00000000;
                        state <= SEND_ACK;
                    end else begin
                        state <= IDLE;
                    end
                end else counter <= counter - 1; 
            end
             
            SEND_ACK: begin
                state <= READ_DATA;
                counter = 5'b11111;
            end
            
            READ_DATA: begin
                data_in[counter] <= i2c_sda;
                if(counter == 0) begin
                    state <= SEND_ACK2;
                    
                end else counter <= counter - 1;
            end
            
            SEND_ACK2: begin
                data_out_intermediate <= data_in;
                rx_done_flag <= 1;
                state <= IDLE;
                counter <= 5'b00110; // this just works
            end
        endcase
    end        
endmodule

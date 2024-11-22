`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2024 01:55:45 PM
// Design Name: 
// Module Name: slave_processing_fsm_top
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


module slave_processing_fsm_top(
    input done,
    input [7:0] slave_data_in,
    output [1:0] cnt,
    input clk
    );
    localparam RX1 = 8'd1,
                RX2 = 8'd2,
                RX3 = 8'd3,
                DECODE = 8'd4;
    reg [7:0] state = RX1;
    reg [1:0] slave_rx_counter = 3;
    reg [7:0] opcode = 0;
    reg [7:0] operand1 = 0;
    reg [7:0] operand2 = 0;
    reg [7:0] OLED_data = 0;
    reg [31:0] OLED_opcode_disp = 0;
    
    assign cnt = slave_rx_counter;
    
    /*
    TODO
    1. Extend I2C and Master data sending lengths to 32 bits
        - Also change all registers in this file
    2. Add done flag to I2C slave module, just needs to toggle at some point, 
        we do not care how long it stays high
    3. Add I2C module to this file
    4. Add in multiplier module
    5. Create a test bench with the master, and this module to see if you can 
        receive 3 pieces of data in a row
    
    
    */
    
    
    
    always @ (posedge done) begin
        if (slave_rx_counter == 3) begin
            slave_rx_counter <= 1;
        end else begin
            slave_rx_counter <= slave_rx_counter + 1; // may need to change this since there's 4 possible cases
        end
    end
    
    
    always @(posedge clk) begin
        
    
        case (state)
            RX1: begin
                if (slave_rx_counter == 1) begin
                    opcode <= slave_data_in;
                    state <= RX2;
                end else begin
                    state <= RX1;
                end
            end
            RX2: begin
                if (slave_rx_counter == 2) begin
                    operand1 <= slave_data_in;
                    state <= RX3;
                end else begin
                    state <= RX2;
                end
            end
            RX3: begin
                if (slave_rx_counter == 3) begin
                    operand2 <= slave_data_in;
                    state <= DECODE;
                end else begin
                    state <= RX3;
                end
            end
            DECODE: begin
                
                case (opcode[1:0])
                    2'b00: begin // ADD
                        OLED_opcode_disp <= {24'h65_68_68, 8'h00}; 
                        OLED_data <= operand1;
                    end    
                    2'b01: begin // SUB 
                        OLED_opcode_disp <= {24'h83_85_66 , 8'h00}; 
                        OLED_data <= operand2;
                    end
                    2'b10:  begin // MULT
                        OLED_opcode_disp <= {24'h83_85_66 , 8'h00};
                        OLED_data <= operand1 * operand2;
                    end
                    2'b11: begin // unused?
                        OLED_opcode_disp <= 32'h77_85_76_84;
                        OLED_data <= 8'b1111_1111;
                    end
                    default: begin  
                        OLED_opcode_disp <= 32'h73_68_76_69 ;
                        OLED_data <= 8'b0000_0000;    
                    end                 
                
                endcase
                // to the rest of the processing
                state <= RX1;
            end
            
        endcase
    
    end
    
    
endmodule

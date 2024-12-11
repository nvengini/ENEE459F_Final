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
    input done, // receive done flag input from i2c slave
    input [31:0] slave_data_rx, // data from i2c slave
    output [1:0] cnt, // debug output to Pmod in top module
    input clk,
	output reg [31:0] OLED_A = 0, // Operand A output to OLED
	output reg [31:0] OLED_B = 0, // Operand B output to OLED
    output reg [31:0] OLED_result = 0, // result output to OLED
    output reg [31:0] OLED_opcode_disp = 0, // opcode output to OLED
    output [2:0] state_out // debug output to Pmod in top module
    );
    localparam RX1 = 3'd1,
                RX2 = 3'd2,
                RX3 = 3'd3,
                DECODE = 3'd4,
				RX4 = 3'd5; 
				
    reg [2:0] state = RX1;
    reg [2:0] slave_rx_counter = 4; 
    reg [31:0] opcode = 0;
    reg [31:0] operand1 = 0;
    reg [31:0] operand2 = 0;
	reg [31:0] result = 0;			
    wire [31:0] mult_out;

    
    assign cnt = slave_rx_counter[1:0];
    assign state_out = state;

    fp_multiplier mult(
        .num1(operand1),
        .num2(operand2),
        .final_product(mult_out)
    );
    
    // counts the number of times 
    // the slave has received a full 32 bits of data
    always @ (posedge done) begin 
        if (slave_rx_counter == 4) begin // Resets the i2c receive counter
            slave_rx_counter <= 1;
        end else begin
            slave_rx_counter <= slave_rx_counter + 1; // increments counter
        end
    end
    
    
    always @(posedge clk) begin
        
    
        case (state)
            RX1: begin
                if (slave_rx_counter == 1) begin // waits for first i2c receive to be complete
                    opcode <= slave_data_rx; // assigns opcode to i2c data
                    state <= RX2;
                end else begin
                    state <= RX1;
                end
            end
            RX2: begin
                if (slave_rx_counter == 2) begin // waits for second i2c receive to be complete
                    operand1 <= slave_data_rx; // assigns operand to i2c data
                    state <= RX3;
                end else begin
                    state <= RX2;
                end
            end
            RX3: begin
                if (slave_rx_counter == 3) begin // waits for third i2c receive to be complete
                    operand2 <= slave_data_rx;  // assigns operand to i2c data
                    state <= RX4;					
                end else begin
                    state <= RX3;
                end
            end
			RX4: begin 								// waits for fourth i2c receive to be complete
                if (slave_rx_counter == 4) begin
                    result <= slave_data_rx; // assigns result to i2c data
                    state <= DECODE;
                end else begin
                    state <= RX4;
                end
            end
            DECODE: begin
                
                case (opcode[1:0])
                    2'b00: begin // ADD
                        OLED_opcode_disp <= {24'h41_44_44, 8'h00}; // sends ASCII for ADD to OLED if opcode is 00
						OLED_A <= operand1;
						OLED_B <= operand2;
                        OLED_result <= result; // result comes from other board's adder/subtractor
                    end    
                    2'b01: begin // SUB 
                        OLED_opcode_disp <= {24'h53_55_42 , 8'h00};
						OLED_A <= operand1;
						OLED_B <= operand2;
                        OLED_result <= result; // result comes from other board's adder/subtractor
                    end
                    2'b10:  begin // MULT
                        OLED_opcode_disp <= {24'h4D_55_4C , 8'h00};
						OLED_A <= operand1;
						OLED_B <= operand2;
                        OLED_result <= mult_out; // result comes from this board's multiplier
                    end
                    2'b11: begin 
                        OLED_opcode_disp <= 32'h6E_6F_6F_70; // unused
						OLED_A <= operand1;
						OLED_B <= operand2;
                        OLED_result <= 8'b1111_1111;
                    end
                    default: begin  
                        OLED_opcode_disp <= 32'h73_68_76_69 ;
                        OLED_result <= 8'b0000_0000;    
                    end                 
                
                endcase
                
                state <= RX1;
            end
            
        endcase
    
    end
    
    
endmodule

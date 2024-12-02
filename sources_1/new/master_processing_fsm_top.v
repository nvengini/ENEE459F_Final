`timescale 1ns/1ps

module master_processing_fsm_top (
    input clk,                  // system clock
    input reset,
    input rx,
    input btn,
    output tx,
    inout i2c_sda,
    inout wire i2c_scl,
    output reg [7:0] led_out = 8'b10010101,
    output [3:0] state_out,
    output [7:0] rec_data_out,
    output rec_flag_out,
    output btn_tick_out,
    output i2c_en_out,
    output ready_out,
    output state_clk_out
);

    // states
    localparam UART1 = 8'd0;
    localparam UART2 = 8'd1;
    localparam UART3 = 8'd2;
    localparam UART4 = 8'd3;
    localparam UART5 = 8'd4;
    localparam UART6 = 8'd5;
    localparam UART7 = 8'd6;
    localparam UART8 = 8'd7;
    localparam UART9 = 8'd8;
    localparam START_ADD = 8'd9;
    localparam WAIT_ADD = 8'd10;
    localparam SEND_OP = 8'd11;
    localparam SEND_DATA1 = 8'd12;
    localparam SEND_DATA2 = 8'd13;
    localparam FINAL_WAIT = 8'd14;
    
    reg [3:0] state = UART1;
    assign state_out = state;
    reg state_clk = 0;
    reg [31:0] counter = 0;
    reg [3:0] rx_ctr = 0;
    reg [71:0] rx_buffer = 72'd0;
    
    reg [31:0] i2c_input = 32'd0;
    wire ready;
    reg [6:0] addr = 7'b0101010;
    reg rw = 1'b0;
    reg i2c_en = 0;
    wire [7:0] rec_data;
    wire updated_rec_data;
    wire btn_tick;
    wire rx_full;
    wire rx_empty;
    
    assign rec_data_out = rec_data;
    assign btn_tick_out = btn_tick;
    assign rec_flag_out = updated_rec_data;
    assign i2c_en_out = i2c_en;
    assign ready_out = ready;
    assign state_clk_out = state_clk;
    //assign updated_rec_data_out = updated_rec_data;
    
    
    
    reg start = 0; reg [31:0] posedge_ctr = 32'd0;
    wire done;
    reg [31:0] input1 = 32'd0;
    reg [31:0] input2 = 32'd0;
    wire [31:0] result;
    
    // Complete UART Core
    uart_top UART_UNIT
        (
            .clk_100MHz(clk), .reset(reset), .read_uart(btn_tick),
            .write_uart(btn_tick), .rx(rx), .write_data(rec_data), // TX back to PC
            .rx_full(rx_full), .rx_empty(rx_empty), .read_data(rec_data), // RX from PC
            .tx(tx), .updated_rec_data(updated_rec_data)
        );
    
    // Button Debouncer
    debounce_explicit BUTTON_DEBOUNCER
        (
            .clk_100MHz(clk), .reset(reset), .btn(btn),         
            .db_level(), .db_tick(btn_tick)
        );
    
    // master I2C controller  
    i2c_master_controller master (
		.clk(clk), .rst(reset), .addr(addr),	.data_in(i2c_input), // Change to UART output
		.enable(i2c_en), // controlled by state machine
		.rw(rw), .data_out(data_out), // unused
		.ready(ready), // map to LED?
		.i2c_sda(i2c_sda), // outputs to other board
		.i2c_scl(i2c_scl) // output to other board
	);
	
	// adder
	fp_add_sub add_sub( .a1(input1), .a2(input2), .clk(state_clk), .start(start), .reset(reset), 
                        .result(result), .done(done)    );
	   
    // check if a message has been sent from the fifo & update ctr
    always @(posedge updated_rec_data) begin
        if(rx_ctr == 9) 
            rx_ctr <= 0;
        else
            rx_ctr <= rx_ctr + 1;
    end
    
    //clock divider to slow down our state machine
    always @(posedge clk) begin
		if (counter == (4000/2) - 1) begin
			state_clk <= ~state_clk;
			counter <= 0;
		end
		else counter <= counter + 1;
	end 
    
    
    //on each clock edge, move through the states.
    always @(posedge state_clk) begin
        case(state)
            UART1: begin
                if(rx_ctr == 1) begin
                    rx_buffer[7:0] <= rec_data;
                    led_out <= rx_buffer[7:0];
                    state <= UART2;    
                end else
                    state <= UART1;
            end
            
            UART2: begin
                if(rx_ctr == 2) begin
                    rx_buffer[15:8] <= rec_data;
                    led_out <= rx_buffer[15:8];
                    state <= UART3;    
                end else
                    state <= UART2;
            end
            
            UART3: begin
                if(rx_ctr == 3) begin
                    rx_buffer[23:16] <= rec_data;
                    led_out <= rx_buffer[23:16];
                    state <= UART4;    
                end else
                    state <= UART3;
            end
            
            UART4: begin
                if(rx_ctr == 4) begin
                    rx_buffer[31:24] <= rec_data;
                    led_out <= rx_buffer[31:24];
                    state <= UART5;    
                end else
                    state <= UART4;
            end
            
            UART5: begin
                if(rx_ctr == 5) begin
                    rx_buffer[39:32] <= rec_data;
                    led_out <= rx_buffer[39:32];
                    state <= UART6;    
                end else
                    state <= UART5;
            end
            
            UART6: begin
                if(rx_ctr == 6) begin
                    rx_buffer[47:40] <= rec_data;
                    led_out <= rx_buffer[47:40];
                    state <= UART7;    
                end else
                    state <= UART6;
            end
            
            UART7: begin
                if(rx_ctr == 7) begin
                    rx_buffer[55:48] <= rec_data;
                    led_out <= rx_buffer[55:48];
                    state <= UART8;    
                end else
                    state <= UART7;
            end
            
            UART8: begin
                if(rx_ctr == 8) begin
                    rx_buffer[63:56] <= rec_data;
                    led_out <= rx_buffer[63:56];
                    state <= UART9;    
                end else
                    state <= UART8;
            end
            
            UART9: begin
                if(rx_ctr == 9) begin
                    rx_buffer[71:64] <= rec_data;
                    led_out <= rx_buffer[71:64];
                    //if add or sub
                    if(rx_buffer[1:0] == 1'b01 || rx_buffer[1:0] == 1'b00)
                        state <= START_ADD;
                    else
                        state <= SEND_OP;
                end else
                    state <= UART9;
            end
       
            START_ADD: begin
                if(rx_buffer[1:0] == 1'b00) begin //adding
                    //set the adder by updating the parameters
                    input1 <= rx_buffer[39:8];
                    input2 <= rx_buffer[71:40];
                end else begin //subtraction
                    //set subtraction by flipping sign bit of 2nd input
                    input1 <= rx_buffer[39:8];
                    input2 <= {~rx_buffer[71], rx_buffer[70:40]};
                end
                start <= 1;
                posedge_ctr <= 32'd4;
                state <= WAIT_ADD;
            end
            
            WAIT_ADD: begin
                if(posedge_ctr != 0) begin
                    posedge_ctr <= posedge_ctr - 1;
                end else begin
                    start <= 0;
                end
                    
                if(done) begin 
                    rx_buffer[39:8] <= result;
                    rx_buffer[71:40] <= 32'd0;
                    state <= SEND_OP;
                end else
                    state <= WAIT_ADD;
            end
            
            SEND_OP: begin
                // already sent i2c_data in last one. Now, wait for next done flag
                if(ready) begin
                    i2c_input = {30'd0, rx_buffer[1:0]};
                    i2c_en = 1;
                    posedge_ctr <= 32'd10;
                    state = SEND_DATA1;
                end else
                    state = SEND_OP;
            end
            
            SEND_DATA1: begin
                if(posedge_ctr != 0) begin
                    posedge_ctr <= posedge_ctr - 1;
                end else begin
                    if(!ready) begin
                        i2c_en = 0;
                        state = SEND_DATA1;
                    end else begin
                        i2c_input = rx_buffer[39:8];
                        i2c_en = 1;
                        posedge_ctr = 32'd10;
                        state = SEND_DATA2;
                    end
                end
            end
            
            SEND_DATA2: begin
                if(posedge_ctr != 0) begin
                    posedge_ctr <= posedge_ctr - 1;
                end else begin
                    if(!ready) begin
                        i2c_en = 0;
                        state = SEND_DATA2;
                    end else begin
                        i2c_input = rx_buffer[71:40];
                        i2c_en = 1;
                        posedge_ctr = 32'd10;
                        state = FINAL_WAIT;
                    end
                end
            end
            
            FINAL_WAIT: begin
            if(posedge_ctr != 0) begin
                    posedge_ctr <= posedge_ctr - 1;
                    state <= FINAL_WAIT;
                end else begin
                    i2c_en = 0;
                    state <= UART1;
                end
            end
            
       endcase
    end
endmodule
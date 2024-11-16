`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineers: Ryan Kim
//				  Josh Sackos
// 
// Create Date:    14:00:51 06/12/2012
// Module Name:    PmodOLEDCtrl 
// Project Name: 	 PmodOLED Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: 	 Top level controller that controls the PmodOLED blocks
//
// Revision: 1.1
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
//module PmodOLEDCtrl(
//		CLK,
//		RST,
//		EN,
//        Page0,
//        Page1,
//        Page2,
//        Page3,
//		CS,
//		SDIN,
//		SCLK,
//		DC,
//		RES,
//		VBAT,
//		VDD,
//		FIN
//    );

module PmodOLEDCtrl(
    input CLK,
    input RST,
    input EN,
    // input [3:0] SW, // 4-bit switch input
    input [7:0] data_in,
    output CS,
    output SDIN,
    output SCLK,
    output DC,
    output RES,
    output VBAT,
    output VDD,
    output FIN
);


	// ===========================================================================
	// 										Port Declarations
//	// ===========================================================================
//	input CLK;
//	input RST;
//	input EN;
//    input[127:0] Page0;
//    input[127:0] Page1;
//    input[127:0] Page2;
//    input[127:0] Page3;
//	output CS;
//	output SDIN;
//	output SCLK;
//	output DC;
//	output RES;
//	output VBAT;
//	output VDD;
//	output FIN;

	// ===========================================================================
	// 							  Parameters, Regsiters, and Wires
	// ===========================================================================
	// wire CS, SDIN, SCLK, DC;
	// wire VDD, VBAT, RES;
	reg[127:0] Page0_reg, Page1_reg, Page2_reg, Page3_reg;
    
	reg [110:0] current_state = "Idle";

	wire init_en;
	wire init_done;
	wire init_cs;
	wire init_sdo;
	wire init_sclk;
	wire init_dc;
	
	wire display_en;
	wire display_cs;
	wire display_sdo;
	wire display_sclk;
	wire display_dc;
	wire display_done;
	// ===========================================================================
	// 										Implementation
	// ===========================================================================
	OledInit Init(
			.CLK(CLK),
			.RST(RST),
			.EN(init_en),
			.CS(init_cs),
			.SDO(init_sdo),
			.SCLK(init_sclk),
			.DC(init_dc),
			.RES(RES),
			.VBAT(VBAT),
			.VDD(VDD),
			.FIN(init_done)
	);
	
	OledEX Display(
			.CLK(CLK),
			.RST(RST),
			.EN(display_en),
			.Page0(Page0_reg),
			.Page1(Page1_reg),
			.Page2(Page2_reg),
			.Page3(Page3_reg),
			.CS(display_cs),
			.SDO(display_sdo),
			.SCLK(display_sclk),
			.DC(display_dc),
			.FIN(display_done)
	);


	//MUXes to indicate which outputs are routed out depending on which block is enabled
	assign CS = (current_state == "OledInitialize") ? init_cs : display_cs;
	assign SDIN = (current_state == "OledInitialize") ? init_sdo : display_sdo;
	assign SCLK = (current_state == "OledInitialize") ? init_sclk : display_sclk;
	assign DC = (current_state == "OledInitialize") ? init_dc : display_dc;
	
	//MUXes that enable blocks when in the proper states
	assign init_en = (current_state == "OledInitialize") ? 1'b1 : 1'b0;
	assign display_en = (current_state == "OledDisplay") ? 1'b1 : 1'b0;
	
   //Display finish flag only high when in done state
    assign FIN = (current_state == "Done") ? 1'b1 : 1'b0;

	
	//  State Machine
//	always @(posedge CLK) begin
//			if(RST == 1'b1) begin
//					current_state <= "Idle";
//			end
//			else begin
//					case(current_state)
//						"Idle" : begin
//							current_state <= "OledInitialize";
//						end
//  					   // Go through the initialization sequence
//						"OledInitialize" : begin
//								if(init_done == 1'b1) begin
//										current_state <= "OledReady";
//								end
//						end
//						"OledReady" : begin
//						        if(EN == 1'b1) begin
//                                        Page0_reg <= Page0;
//                                        Page1_reg <= Page1;
//                                        Page2_reg <= Page2;
//                                        Page3_reg <= Page3;
//						                current_state <= "OledDisplay";
//						        end
//						end
//						// Do Display and go into Done state when finished
//						"OledDisplay" : begin
//								if(display_done == 1'b1) begin
//										current_state <= "Done";
//								end
//						end			
						
//						// If EN is de-asserted, go back to Ready state
//						"Done" : begin
//                                if(EN == 1'b0) begin
//                                    current_state <= "OledReady";
//                                end
//                        end
						
//						default : current_state <= "Idle";
//					endcase
//			end
//	end

//    function [127:0] num_to_oled;
//        input [3:0] num;
//        begin
//            case(num)
//                4'h0: num_to_oled = 128'h00_3C_42_42_42_42_42_3C_00_00_00_00_00_00_00_00; // 0
//                4'h1: num_to_oled = 128'h00_08_18_28_08_08_08_3E_00_00_00_00_00_00_00_00; // 1
//                4'h2: num_to_oled = 128'h00_3C_42_02_0C_30_40_7E_00_00_00_00_00_00_00_00; // 2
//                4'h3: num_to_oled = 128'h00_3C_42_02_1C_02_42_3C_00_00_00_00_00_00_00_00; // 3
//                4'h4: num_to_oled = 128'h00_04_0C_14_24_44_7E_04_00_00_00_00_00_00_00_00; // 4
//                4'h5: num_to_oled = 128'h00_7E_40_78_04_02_44_38_00_00_00_00_00_00_00_00; // 5
//                4'h6: num_to_oled = 128'h00_1C_20_40_7C_42_42_3C_00_00_00_00_00_00_00_00; // 6
//                4'h7: num_to_oled = 128'h00_7E_02_04_08_10_20_20_00_00_00_00_00_00_00_00; // 7
//                4'h8: num_to_oled = 128'h00_3C_42_42_3C_42_42_3C_00_00_00_00_00_00_00_00; // 8
//                4'h9: num_to_oled = 128'h00_3C_42_42_3E_02_04_38_00_00_00_00_00_00_00_00; // 9
//                default: num_to_oled = 128'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00;
//            endcase
//        end
//    endfunction

//    // State Machine
//    always @(posedge CLK) begin
//        if (RST == 1'b1) begin
//            current_state <= "Idle";
//        end
//        else begin
//            case(current_state)
//                "Idle" : begin
//                    current_state <= "OledInitialize";
//                end
//                "OledInitialize" : begin
//                    if(init_done == 1'b1) begin
//                        current_state <= "OledReady";
//                    end
//                end
//                "OledReady" : begin
//                    if(EN == 1'b1) begin
//                        case(SW)
//                            4'b0001: Page0_reg <= num_to_oled(4'h1); // Display 1 when SW[0] is on
//                            4'b0010: Page0_reg <= num_to_oled(4'h3); // Display 3 when SW[1] is on
//                            4'b0100: Page0_reg <= num_to_oled(4'h5); // Display 5 when SW[2] is on
//                            4'b1000: Page0_reg <= num_to_oled(4'h7); // Display 7 when SW[3] is on
//                            default: Page0_reg <= num_to_oled(4'h0); // Display 0 for any other combination
//                        endcase
//                        Page1_reg <= 128'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00;
//                        Page2_reg <= 128'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00;
//                        Page3_reg <= 128'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00;
//                        current_state <= "OledDisplay";
//                    end
//                end
//                "OledDisplay" : begin
//                    if(display_done == 1'b1) begin
//                        current_state <= "Done";
//                    end
//                end
//                "Done" : begin
//                    if(EN == 1'b0) begin
//                        current_state <= "OledReady";
//                    end
//                end
//                default : current_state <= "Idle";
//            endcase
//        end
//    end



//    reg [127:0] Page0_reg, Page1_reg, Page2_reg, Page3_reg;
//    reg [110:0] current_state = "Idle";

    // Define the text for each page
//    localparam [127:0] PAGE0_TEXT = {8'h57, 8'h65, 8'h6C, 8'h63, 8'h6F, 8'h6D, 8'h65, 8'h20, 8'h74, 8'h6F, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20}; // "Welcome to      "
//    localparam [127:0] PAGE1_TEXT = {8'h45, 8'h4E, 8'h45, 8'h45, 8'h33, 8'h35, 8'h39, 8'h46, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20}; // "ENEE359F        "
//    localparam [127:0] PAGE2_TEXT = {8'h4C, 8'h61, 8'h62, 8'h20, 8'h37, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20}; // "Lab 7           "
//    localparam [127:0] PAGE3_TEXT_BASE = {8'h53, 8'h57, 8'h30, 8'h3D, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20}; // "SW0=            "

    // ... (keep existing module instantiations for OledInit and OledEX)


// Define the text for each page
localparam [127:0] PAGE0_TEXT = {8'h45, 8'h4E, 8'h45, 8'h45, 8'h34, 8'h35, 8'h39, 8'h46, 8'h0A, 8'h0A, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20}; // "ENEE459F\n\n      "
localparam [127:0] PAGE1_TEXT = {8'h4F, 8'h4C, 8'h45, 8'h44, 8'h20, 8'h54, 8'h45, 8'h53, 8'h54, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20}; // "OLED TEST       "
localparam [127:0] PAGE2_TEXT = {8'h42, 8'h79, 8'h20, 8'h59, 8'h6F, 8'h75, 8'h72, 8'h4E, 8'h61, 8'h6D, 8'h65, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20}; // "By YourName        "
localparam [127:0] PAGE3_TEXT_BASE = {8'h53, 8'h75, 8'h63, 8'h63, 8'h65, 8'h73, 8'h73, 8'h21, 8'h21, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20}; // "Success!!       "
    
    function [15:0] convert_to_ascii_hex; // NSV Changed
        input [7:0] bin;
        reg [7:0] upper_nibble_ascii;
        reg [7:0] lower_nibble_ascii;
        begin
            if (bin[7:4] < 4'd10)
                upper_nibble_ascii = 8'h30 + bin[7:4];
            else
                upper_nibble_ascii = 8'h37 + bin[7:4];
            
            if (bin[3:0] < 4'd10)
                lower_nibble_ascii = 8'h30 + bin[3:0];
            else
                lower_nibble_ascii = 8'h37 + bin[3:0];
            
            convert_to_ascii_hex = {upper_nibble_ascii, lower_nibble_ascii};
        end
    endfunction
    // State Machine
    always @(posedge CLK) begin
        if (RST == 1'b1) begin
            current_state <= "Idle";
            Page0_reg <= 128'h00000000000000000000000000000000; // Clear display on reset
            Page1_reg <= 128'h00000000000000000000000000000000;
            Page2_reg <= 128'h00000000000000000000000000000000;
            Page3_reg <= 128'h00000000000000000000000000000000;
        end
        else begin
            case(current_state)
                "Idle" : begin
                    current_state <= "OledInitialize";
                end
                "OledInitialize" : begin
                    if(init_done == 1'b1) begin
                        current_state <= "OledReady";
                    end
                end
                "OledReady" : begin
                    if(EN == 1'b1) begin
                        // Update pages based on switch status
                        Page0_reg <= {data_in, 112'h000000000000000000000000000000};
                        Page1_reg <= PAGE1_TEXT;
                        Page2_reg <= 128'h00000000000000000000000000000000;
                        Page3_reg <= 128'h00000000000000000000000000000000;
                        current_state <= "OledDisplay";
                    end
                end
                "OledDisplay" : begin
                    if(display_done == 1'b1) begin
                        current_state <= "Done";
                    end
                end
                "Done" : begin
//                    if(EN == 1'b0) begin          // NSV Changed
//                        current_state <= "OledReady";
//                    end
                    current_state <= "OledReady";
                end
                default : current_state <= "Idle";
            endcase
        end
    end
endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2020 06:25:56 AM
// Design Name: 
// Module Name: charLib
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



module charLib(
    input clka,
    input [10:0] addra,
    output reg [7:0] douta
    );
    
    
    reg [7:0] charLib_ram [0:1023];

    
    initial begin
	$readmemh("char_data_h.mem",charLib_ram);
    end

    
	always @(posedge clka)
	begin
	    douta <= charLib_ram[addra];
	end 
	
endmodule

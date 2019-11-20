`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:33:28 11/20/2019 
// Design Name: 
// Module Name:    display_seven_segment 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module display_seven_segment(
		input wire [3:0] i_score_player_1,
		input wire [3:0] i_score_player_2,
		input wire i_clk_200Hz,
		output wire [6:0] o_data,
		output reg [5:0] o_comm
    );
	 
		reg [3:0] selected_score;
	
		always @ (*)
		begin
			if (i_clk_200Hz)
			begin
				selected_score <= i_score_player_1;
				o_comm  = 6'b111110;		
			end
			else
			begin
				selected_score <= i_score_player_2;
				o_comm  = 6'b011111;
			end
		end
		
		wire [6:0] temp_data;
		
		decimal_to_seven_segment converter(
			.i_decimal(selected_score),
			.o_seven_segment(temp_data)
		);
		
		assign o_data = ~temp_data;

endmodule

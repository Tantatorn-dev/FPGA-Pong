`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:59:26 11/19/2019 
// Design Name: 
// Module Name:    scoreboard 
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
module scoreboard(
	input wire i_goal_player_1,
	input wire i_goal_player_2,
	output reg [3:0] o_score_player_1=0,
	output reg [3:0] o_score_player_2=0
    );
	 
	always @ (posedge i_goal_player_1)
	begin
		if(o_score_player_1 == 6)
		o_score_player_1 = 0;
		else
		o_score_player_1 = o_score_player_1 + 1;
	end
	
	always @ (posedge i_goal_player_2)
	begin
		if(o_score_player_2 == 6)
		o_score_player_2 = 0;
		else
		o_score_player_2 = o_score_player_2 + 1;
	end

endmodule

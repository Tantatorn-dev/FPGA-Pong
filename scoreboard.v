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
	input wire i_restart_game_btn,
	output reg [3:0] o_score_player_1=0,
	output reg [3:0] o_score_player_2=0,
	output reg o_buzzer = 1,
	input wire i_clk
    );
	 
	reg temp_state=0;
	
	
//	always @ (posedge i_goal_player_1 or posedge i_goal_player_2)
//	begin
//		
//		if(i_goal_player_1 == 1) begin
//		
//		if(o_score_player_1 == 5)
//		begin
//		o_score_player_1 <= 0;
//		end
//		else
//		begin
//		o_score_player_1 <= o_score_player_1 + 1;
//		end
//		
//		end
//		
//		else  begin
//		
//		if(o_score_player_2 == 5)
//		begin
//		o_score_player_2 <= 0;
//		end
//		else
//		begin
//		o_score_player_2 <= o_score_player_2 + 1;
//		end
//		
//		
//	
//	end
//	end
	
	always @ (posedge i_goal_player_1) begin
		if(o_score_player_1 == 5)
		begin
		o_score_player_1 <= 0;
		end
		else
		o_score_player_1 <= o_score_player_1 + 1;
	end
	
	
	
	always @ (posedge i_goal_player_2)
	begin
		if(o_score_player_2 == 5)
		begin
		o_score_player_2 <= 0;
		end
		else
		o_score_player_2 <= o_score_player_2 + 1;
	end
	
	always @(*) begin
		
	end 
//	

// wire goal_trig;
//	
//	assign goal_trig = i_goal_player_1 || i_goal_player_2;
//	
//	always @ (posedge goal_trig)
//	begin
//		
//			if(o_score_player_1 == 5)
//				begin
//				victory_state = 1;
//				end
//			else
//				begin
//				if(i_goal_player_1)
//				o_score_player_1 = o_score_player_1 + 1;
//				end
//		
//		
//		
//			begin
//				if(o_score_player_2 == 5)
//					begin
//					victory_state  =1;
//					end
//				else
//					begin
//					if(i_goal_player_2)
//					o_score_player_2 = o_score_player_2 + 1;
//					end
//		
//		
//		if( victory_state==1)
//		begin
//			o_score_player_1 = 0;
//			o_score_player_2 = 0;
//			victory_state = 0;
//		end
//	end
//	end

endmodule

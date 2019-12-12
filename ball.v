`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:45:31 11/07/2019 
// Design Name: 
// Module Name:    ball 
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
module ball #(
	 SIZE=10, 
    IX=320,         // initial horizontal position of square centre
    IY=240,         // initial vertical position of square centre
    D_WIDTH=640,    // width of display
    D_HEIGHT=480    // height of display
    )
	 (
	 input wire i_clk,         // base clock
    input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    input wire i_rst,         // reset: returns animation to starting position
    input wire i_animate,     // animate when input is hig
	 
	 // to create a collision
	 input wire [11:0] i_paddle_a_x, 
	 input wire [11:0] i_paddle_b_x,
	 
	 // direction of paddle
	 input wire [1:0] i_paddle_a_dir,
	 input wire [1:0] i_paddle_b_dir,
	
	 // output
    output wire [11:0] o_x1,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x2,  // square right edge
    output wire [11:0] o_y1,  // square top edge
    output wire [11:0] o_y2,   // square bottom edge
	 
	 // goal output !!
	 output reg o_goal_player_1,
	 output reg o_goal_player_2,
	 
	 output reg [3:0] o_score_player_1 = 0,
	 output reg [3:0] o_score_player_2 = 0
	 );
	 
	 reg [11:0] x = IX;   // horizontal position of ball centre
    reg [11:0] y = IY;   // vertical position of ball centre

    assign o_x1 = x - SIZE;  
    assign o_x2 = x + SIZE;  
    assign o_y1 = y - SIZE;  
    assign o_y2 = y + SIZE;
	 
	 reg [3:0] direction = 1;

    always @ (posedge i_clk)
    begin
        if (i_rst)  // on reset return to starting position
        begin
            x <= IX;
            y <= IY;
        end
        if (i_animate && i_ani_stb)
        begin
		  
				// check goal!!!!!!!!!
				if (y == 470)
				begin
					direction = 8;
				end
				else if (y==10)
				begin
					direction = 7;
				end				
				
				// boundary check
				if (x >= 600 && direction == 6) 
					 direction = 5;
				else if (x <= 80  && direction == 5)
					 direction = 6;
				else if (x >= 600 && direction == 3) 
					 direction = 2;
				else if (x <= 80  && direction == 2)
					 direction = 3;
				
				// direction of a ball
				if (y >= 435 && x >= i_paddle_a_x && x <= i_paddle_a_x +100 && i_paddle_a_dir == 2) 
					direction = 4;
				else if (y >= 435 && x >= i_paddle_a_x && x <= i_paddle_a_x +100 && i_paddle_a_dir == 0) 
					direction = 6;
				else if (y >= 435 && x >= i_paddle_a_x && x <= i_paddle_a_x +100 && i_paddle_a_dir == 1) 
					direction = 5;
				else if (y <= 35 && x >= i_paddle_b_x && x <= i_paddle_b_x +100 && i_paddle_b_dir == 2)
					direction = 1;
				else if (y <= 35 && x >= i_paddle_b_x && x <= i_paddle_b_x +100 && i_paddle_b_dir == 0) 
					direction = 3;
				else if (y <= 35 && x >= i_paddle_b_x && x <= i_paddle_b_x +100 && i_paddle_b_dir == 1) 
					direction = 2;
					 
				if (direction == 1) // S
				begin
				o_goal_player_1 = 0;
				o_goal_player_2 = 0;
				y<= y+1; 
				end
				else if (direction == 2) // SW
				begin
				o_goal_player_1 = 0;
				o_goal_player_2 = 0;
				y <= y+1;
				x <= x-1;
				end
				else if (direction == 3) // SE
				begin
				o_goal_player_1 = 0;
				o_goal_player_2 = 0;
				y <= y+1;
				x <= x+1;
				end
				else if (direction == 4) // N
				begin
				o_goal_player_1 = 0;
				o_goal_player_2 = 0;
				y<= y-1; 
				end
				else if (direction == 5) // NW
				begin
				o_goal_player_1 = 0;
				o_goal_player_2 = 0;
				y <= y-1;
				x <= x-1;
				end
				else if (direction == 6) // NE
				begin
				o_goal_player_1 = 0;
				o_goal_player_2 = 0;
				y <= y-1;
				x <= x+1;
				end
				else if (direction == 7)  // RESET pos and dir
				begin
				o_goal_player_1 = 1;
				o_goal_player_2 = 0;
				x <= IX;
				y <= IY;
				direction = 1;
				
				if (o_score_player_1 == 5)
				begin
				o_score_player_1 = 0;
				o_score_player_2 = 0;
				end
				else
				o_score_player_1 = o_score_player_1 + 1;
				end
				else if (direction == 8) // same same with above
				begin
				o_goal_player_1 = 0;
				o_goal_player_2 = 1;
				x <= IX;
				y <= IY;
				direction = 4;
				
				if (o_score_player_2 == 5)
				begin
				o_score_player_1 = 0;
				o_score_player_2 = 0;
				end
				else
				o_score_player_2 = o_score_player_2 + 1;
				
				end
								 
		  end
    end
	 

endmodule

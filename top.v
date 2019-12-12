`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:47:41 11/03/2019 
// Design Name: 
// Module Name:    top 
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
module top(
    input wire CLK,             // board clock: 100 MHz on Arty/Basys3/Nexys
    input wire RST_BTN,         // reset button
    output wire VGA_HS_O,       // horizontal sync output
    output wire VGA_VS_O,       // vertical sync output
    output wire [4:0] VGA_R,    // 5-bit VGA red output
    output wire [5:0] VGA_G,    // 6-bit VGA green output
    output wire [4:0] VGA_B,     // 5-bit VGA blue output
	 
	 // user input
	 input wire LEFT_BTN_1,       
	 input wire RIGHT_BTN_1,
	 input wire LEFT_BTN_2,
	 input wire RIGHT_BTN_2,
	 
	 input wire LEFT_JOYCON_1,
	 input wire RIGHT_JOYCON_1,
	 input wire LEFT_JOYCON_2,
	 input wire RIGHT_JOYCON_2,
	 
	 // seven segment output
	 output wire [6:0] SEVEN_SEG_DATA,
	 output wire [5:0] SEVEN_SEG_COMM
	 
	 
	
    );

    wire rst = ~RST_BTN;    
	 
	 wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-511
    wire animate;  // high when we're ready to animate at end of drawing

    // generate a 25 MHz pixel strobe
    reg [15:0] cnt;
    reg pix_stb;
    always @(posedge CLK)
        {pix_stb, cnt} <= cnt + 16'h8000;  // divide by 4: (2^16)/4 = 0x4000

	// clock divider for 7 segment module ( divide to 200Hz)
	reg[27:0] counter = 28'd0;
	parameter DIVISOR = 28'd250000;
	wire clk_200Hz;
	always @ (posedge CLK) begin
		counter <= counter + 28'd1;
		if(counter >= (DIVISOR-1))
		counter <= 28'd0;
	end
	assign clk_200Hz = (counter<DIVISOR/2)?1'b0:1'b1;
	
	// clock divider for scoreboard module ( divide to 10Hz)
	reg[27:0] counter_2 = 28'd0;
	parameter DIVISOR_2 = 28'd25000000;
	wire clk_10Hz;
	always @ (posedge CLK) begin
		counter_2 <= counter_2 + 28'd1;
		if(counter_2 >= (DIVISOR_2-1))
		counter_2 <= 28'd0;
	end
	assign clk_10Hz = (counter_2<DIVISOR_2/2)?1'b0:1'b1;

    vga640x480 display (
        .i_clk(CLK),
        .i_pix_stb(pix_stb),
        .i_rst(rst),
        .o_hs(VGA_HS_O), 
        .o_vs(VGA_VS_O), 
        .o_x(x), 
        .o_y(y),
		  .o_animate(animate)
    );
  
	 wire paddle_a;
    wire [11:0] paddle_a_x1, paddle_a_x2, paddle_a_y1, paddle_a_y2;  // 12-bit values: 0-4095 
	 
	 wire paddle_b;
    wire [11:0] paddle_b_x1, paddle_b_x2, paddle_b_y1, paddle_b_y2;  // 12-bit values: 0-4095

	 wire b_is_for_ball;
    wire [11:0] ball_x1, ball_x2, ball_y1, ball_y2;  // 12-bit values: 0-4095
	 
	 // paddle direction
	 wire [1:0] paddle_a_dir;
	 wire [1:0] paddle_b_dir;
	 
	 // goal wires
	 wire goal_player_1;
	 wire goal_player_2;
	 
	 // score wires
	 wire [3:0] score_player_1;
	 wire [3:0] score_player_2;
	 
	 paddle #(.IX(310), .IY(450), .H_SIZE(50), .V_SIZE(5)) player_1 (
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(paddle_a_x1),
        .o_x2(paddle_a_x2),
        .o_y1(paddle_a_y1),
        .o_y2(paddle_a_y2),
		  .o_direction(paddle_a_dir),
		  .i_left_btn(LEFT_JOYCON_1),
		  .i_right_btn(RIGHT_JOYCON_1)
    );
	 
	 paddle #(.IX(310), .IY(20), .H_SIZE(50), .V_SIZE(5)) player_2 (
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(paddle_b_x1),
        .o_x2(paddle_b_x2),
        .o_y1(paddle_b_y1),
        .o_y2(paddle_b_y2),
		  .o_direction(paddle_b_dir),
		  .i_left_btn(LEFT_JOYCON_2),
		  .i_right_btn(RIGHT_JOYCON_2)
    );
	 
	 ball  ball_1 (
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
		  .i_paddle_a_x(paddle_a_x1),
		  .i_paddle_b_x(paddle_b_x1),
		  .i_paddle_a_dir(paddle_a_dir),
		  .i_paddle_b_dir(paddle_b_dir),
        .o_x1(ball_x1),
        .o_x2(ball_x2),
        .o_y1(ball_y1),
        .o_y2(ball_y2),
		  .o_goal_player_1(goal_player_1),
		  .o_goal_player_2(goal_player_2),
		  .o_score_player_1(score_player_1),
		  .o_score_player_2(score_player_2)
    );
	 
	 display_seven_segment disp_7 (
		.i_score_player_1(score_player_1),
		.i_score_player_2(score_player_2),
		.i_clk_200Hz(clk_200Hz),
		.o_data(SEVEN_SEG_DATA),
		.o_comm(SEVEN_SEG_COMM)
	 );
	
    assign paddle_a = ((x > paddle_a_x1) & (y > paddle_a_y1) &
        (x < paddle_a_x2) & (y < paddle_a_y2)) ? 1 : 0;
	 assign paddle_b = ((x > paddle_b_x1) & (y > paddle_b_y1) &
        (x < paddle_b_x2) & (y < paddle_b_y2)) ? 1 : 0;
	 assign b_is_for_ball = ((x > ball_x1) & (y > ball_y1) &
        (x < ball_x2) & (y < ball_y2)) ? 1 : 0;
		  

    assign VGA_R[4:0] = {5{paddle_a}};  // square a is red
	 assign VGA_G[5:0] = {6{b_is_for_ball}};
	 assign VGA_B[4:0] = {5{paddle_b}};  // square b is blue 
	 
endmodule

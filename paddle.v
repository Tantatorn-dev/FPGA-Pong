`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:55:04 11/03/2019 
// Design Name: 
// Module Name:    spaceship 
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
module paddle #(
	 H_SIZE=80,      
	 V_SIZE = 30,
    IX=320,         // initial horizontal position of square centre
    IY=240,         // initial vertical position of square centre
    D_WIDTH=640,    // width of display
    D_HEIGHT=480    // height of display
    )
	 (
	 input wire i_clk,         // base clock
    input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    input wire i_rst,         // reset: returns animation to starting position
    input wire i_animate,     // animate when input is high
	 
	 // user input
	 input wire i_left_btn,      
	 input wire i_right_btn, 
	 input wire i_up_btn,
	 input wire i_down_btn,
	
	 // output
    output wire [11:0] o_x1,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x2,  // square right edge
    output wire [11:0] o_y1,  // square top edge
    output wire [11:0] o_y2,   // square bottom edge
	 output reg [1:0] o_direction = 2
	 );
	 
	 reg [11:0] x = IX;   // horizontal position of square centre
    reg [11:0] y = IY;   // vertical position of square centre

    assign o_x1 = x - H_SIZE;  // left: centre minus half horizontal size
    assign o_x2 = x + H_SIZE;  // right
    assign o_y1 = y - V_SIZE;  // top
    assign o_y2 = y + V_SIZE;  // bottom
	 
	 reg [2:0] speed = 1;

    always @ (posedge i_clk)
    begin
        if (i_rst)  // on reset return to starting position
        begin
            x <= IX;
            y <= IY;
        end
        if (i_animate && i_ani_stb)
        begin
				
            if (!i_right_btn && i_left_btn)  // push the right btn
					 o_direction <= 0;
            else if (!i_left_btn && i_right_btn)  // push the left btn
                o_direction <= 1;
            else           
					 o_direction <= 2;
					 
				if (!i_up_btn && i_down_btn)
					if (speed == 7)
					speed = 6;
					else
					speed = speed + 1;
				else if (i_up_btn && !i_down_btn)
					if (speed <= 0)
					speed = 1;
					else
					speed = speed - 1;
					 
					
					 
				if (o_direction == 0)
					x<=x+speed;
				else if (o_direction == 1)
					x<=x-speed;
				else if (o_direction == 2)
					x<=x;
				
				// boundary check
				if (x >= 600) 
					 x<=x-1;
				if (x <= 80)
					 x<=x+1;
					 
				
					 
		  end
    end
	 

endmodule

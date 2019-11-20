`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:39:55 11/20/2019 
// Design Name: 
// Module Name:    decimal_to_seven_segment 
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
module decimal_to_seven_segment(
    input  [3:0] i_decimal,
    output reg [6:0] o_seven_segment
    );
	 
	 always @ (*)
	 begin
		case (i_decimal)
			0: o_seven_segment <= 7'b1111110;
			1: o_seven_segment <= 7'b0110000;
			2: o_seven_segment <= 7'b1101101;
			3: o_seven_segment <= 7'b1111001;
			4: o_seven_segment <= 7'b0110011;
			5: o_seven_segment <= 7'b1011011;
			6: o_seven_segment <= 7'b1011111;
			7: o_seven_segment <= 7'b1110000;
			8: o_seven_segment <= 7'b1111111;
			9: o_seven_segment <= 7'b1111011;
			default: o_seven_segment <= 7'b0000000;
		endcase
	 end

endmodule

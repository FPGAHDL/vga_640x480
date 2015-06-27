`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:17:18 06/27/2015 
// Design Name: 
// Module Name:    image_generator 
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
module image_generator(
    input [9:0] h,
    input [9:0] v,
    output reg [2:0] red,
    output reg [2:0] green,
    output reg [1:0] blue
    );


// display 100% saturation colorbars
// ------------------------
// Combinational "always block", which is a block that is
// triggered when anything in the "sensitivity list" changes.
// The asterisk implies that everything that is capable of triggering the block
// is automatically included in the sensitivty list.  In this case, it would be
// equivalent to the following: always @(hc, vc)
// Assignment statements can only be used on type "reg" and should be of the "blocking" type: =
always @(*)
begin
	// first check if we're within vertical active video range
	if (v >= 0 && v < 480)
	begin
		// now display different colors every 80 pixels
		// while we're within the active horizontal range
		// -----------------
		// display white bar
		if (h >= 0 && h < 80)
		begin
			if(v >= 0 && v < 240 )begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			else begin
				red = 3'b000;
				green = 3'b000;
				blue = 2'b11;
			end
		end
		// display yellow bar
		else if (h >= 80 && h < 160)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b00;
		end
		// display cyan bar
		else if (h >= 160 && h < 240 )
		begin
			red = 3'b000;
			green = 3'b111;
			blue = 2'b11;
		end
		// display green bar
		else if (h >= 240 && h < 320)
		begin
			red = 3'b000;
			green = 3'b111;
			blue = 2'b00;
		end
		// display magenta bar
		else if (h >= 320 && h < 400)
		begin
			red = 3'b111;
			green = 3'b000;
			blue = 2'b11;
		end
		// display red bar
		else if (h >= 400 && h < 480)
		begin
			red = 3'b111;
			green = 3'b000;
			blue = 2'b00;
		end
		// display blue bar
		else if (h >= 480 && h < 560)
		begin
			red = 3'b000;
			green = 3'b000;
			blue = 2'b11;
		end
		// display black bar
		else if (h >= 560 && h < 640)
		begin
			red = 3'b000;
			green = 3'b000;
			blue = 2'b00;
		end
		// we're outside active horizontal range so display black
		else
		begin
			red = 0;
			green = 0;
			blue = 0;
		end
	end
	// we're outside active vertical range so display black
	else
	begin
		red = 0;
		green = 0;
		blue = 0;
	end
end


endmodule

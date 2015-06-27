`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:30:38 03/19/2013 
// Design Name: 
// Module Name:    vga640x480 
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
module vga640x480(
	input wire dclk,			//pixel clock: 25MHz
	input wire clr,			//asynchronous reset
	input wire [2:0] i_red,   //red vga input
	input wire [2:0] i_green, //green vga input
	input wire [1:0] i_blue,   //blue vga input
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	output wire [2:0] red,   //red vga output
	output wire [2:0] green, //green vga output
	output wire [1:0] blue,   //blue vga output
	output wire [9:0] h,	//horizontal line pos
	output wire [9:0] v //vertica line pos
	);

// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480

// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;

// Horizontal & vertical counters --
// this is how we keep track of where we are on the screen.
// ------------------------
// Sequential "always block", which is a block that is
// only triggered on signal transitions or "edges".
// posedge = rising edge  &  negedge = falling edge
// Assignment statements can only be used on type "reg" and need to be of the "non-blocking" type: <=
always @(posedge dclk or posedge clr)
begin
	// reset condition
	if (clr == 1)
	begin
		hc <= 0;
		vc <= 0;
	end
	else
	begin
		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end
		
	end
end

// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type: wire
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;

wire isValid;

assign h =  ((hc >= hbp) && (hc < hfp)) ? hc-hbp : 0;
assign v =  ((vc >= vbp) && (vc < vfp)) ? vc-vbp : 0;
assign isValid = ((vc >= vbp) && (vc < vfp) && (hc >= hbp) && (hc < hfp)) ? 1 : 0;
assign red = (isValid == 1 ) ? i_red : 0;
assign green = (isValid == 1 ) ? i_green : 0 ;
assign blue = (isValid == 1 ) ? i_blue : 0;

endmodule

		`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:28:25 03/19/2013 
// Design Name: 
// Module Name:    NERP_demo_top 
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
module NERP_demo_top(
	input wire clk,			//master clock = 50MHz
	input wire clr,			//right-most pushbutton for reset
	input wire clkin,
	output wire [6:0] seg,	//7-segment display LEDs
	output wire [3:0] an,	//7-segment display anode enable
	output wire dp,			//7-segment display decimal point
	output wire [2:0] red,	//red vga output - 3 bits
	output wire [2:0] green,//green vga output - 3 bits
	output wire [1:0] blue,	//blue vga output - 2 bits
	output wire hsync,		//horizontal sync out
	output wire vsync,			//vertical sync out
	output wire [7:0] Led
	);



	reg [23:0] counter;
   
   always @(posedge clkin)begin
      if (clr)begin
         counter <= 0;
		end
		else begin
		counter <= counter + 1;
		end
	end
	
	
assign Led[0]=counter[23];
assign Led[1]=~counter[20];
assign Led[2]=counter[20];
assign Led[3]=~counter[20];
assign Led[4]=counter[20];
assign Led[5]=~counter[20];
assign Led[6]=counter[20];
assign Led[7]=~counter[20];

// 7-segment clock interconnect
wire segclk;

// VGA display clock interconnect
wire dclk;

// disable the 7-segment decimal points
assign dp = 1;

//internal h v  and r g b signals
wire [9:0] h;
wire [9:0] v;
wire [2:0] r;
wire [2:0] g;
wire [1:0] b;

// generate 7-segment clock & display clock
clockdiv U1(
	.clk(clk),
	.clr(clr),
	.segclk(segclk),
	.dclk(dclk)
	);

// 7-segment display controller
segdisplay U2(
	.segclk(segclk),
	.clr(clr),
	.seg(seg),
	.an(an)
	);

// VGA controller
vga640x480 U3(
	.dclk(dclk),
	.clr(clr),
	.i_red(r),
	.i_green(g),
	.i_blue(b),
	.hsync(hsync),
	.vsync(vsync),
	.red(red),
	.green(green),
	.blue(blue),
	.h(h),
	.v(v)
	);
//Image generator
image_generator U4(
    .h(h), 
    .v(v), 
    .red(r), 
    .green(g), 
    .blue(b)
    );


endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:43:07 06/15/2012 
// Design Name: 
// Module Name:    background 
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
module background(
   input wire [9:0] pixel_x,
	input wire [9:0] pixel_y,
	input wire clk, reset, update_signal,
	output reg [2:0] rgb
	);
		
	localparam [2:0]
		NEGRO 	= 3'b000,
		AZUL		= 3'b001,
		VERDE		= 3'b010,
		CYAN		= 3'b011,
		ROJO		= 3'b100,
		MAGENTA	= 3'b101,
		AMARILLO = 3'b110,
		BLANCO	= 3'b111;
	
	localparam
		ROADMARK_XSTART = 124,
		ROADMARK_XEND = 132,
		ROADMARK_YLEN = 64,
		ROADMARK_YSTGAP = 42;
	
	reg [5:0] scroll_reg, scroll_next; 
	always @(posedge clk, posedge reset)
	begin
		if( reset)
			scroll_reg <= 0;
		else if(update_signal)
			scroll_reg <= scroll_next;
	end

	always @*
	begin
			scroll_next = scroll_reg+1;
	end
	
	always@*
	begin
		case ( pixel_x[9:8] )
			2'b00: // Primera parte del fondo
				if(pixel_x >= 10'b0011111000)
					rgb = BLANCO;
				else
					rgb = VERDE;
			2'b01:
				if ( ROADMARK_XEND >= pixel_x[7:0] && pixel_x[7:0] >= ROADMARK_XSTART )
					if ( (pixel_y-scroll_reg) % ROADMARK_YLEN > ROADMARK_YSTGAP)
						rgb = NEGRO;
					else
						rgb = AMARILLO;
				else
					rgb = NEGRO;
			2'b10:
				if(pixel_x >= 10'b1000000000 && pixel_x <= 10'b1000001000)
					rgb = BLANCO;
				else
					rgb = VERDE;
			default:
				rgb = VERDE;
		endcase
	end

endmodule
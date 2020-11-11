module title_screen
(
	input Clk, Reset, frame_clk,
	input keypress,
	input [9:0] DrawX, DrawY,
	output logic is_char,
	output logic is_title
	);

	logic [10:0] X_Center = 85;
	logic [10:0] Y_Center = 150;
	logic [10:0] size_x = 480;
	logic [10:0] size_y = 113;
	logic opener;
	
	logic [9:0] X_Pos, Y_Pos;
	
	logic color;
	title_text(.Clk, .read_address((DrawX-X_Pos)+(DrawY-Y_Pos)*480), .data_Out(color));
	
	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk) begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end
	
	always_ff @ (posedge Clk)
	begin
		opener <= opener;
		if(Reset)
		begin
			opener <= 1;
			X_Pos <= X_Center;
			Y_Pos <= Y_Center;
		end
		else if(keypress)
			opener <= 0;
		else
		begin
			X_Pos <= X_Pos;
			Y_Pos <= Y_Pos;
		end
	end
	
	always_comb
	begin
		if(opener == 0)
		begin
			is_char = 0;
		end
		else if(DrawX >= X_Pos && DrawX < X_Pos + size_x && DrawY >= Y_Pos && DrawY < Y_Pos + size_y)
		begin
			is_char = color;
		end
		else 
		begin
			is_char = 0;
		end
	end
	
	assign is_title = opener;
endmodule
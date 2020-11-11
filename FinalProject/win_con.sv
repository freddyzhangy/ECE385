module win_con
(
	input Clk, Reset, frame_clk,
	input [3:0] score1, score2,
	input [9:0] DrawX, DrawY,
	output logic is_end
	);
	
	
	logic [10:0] X_Center = 85;
	logic [10:0] Y_Center = 150;
	logic [10:0] size_x = 160;
	logic [10:0] size_y = 39;
	logic winner;
	logic [10:0] win_center_x = 250;
	logic [10:0] win_center_y = 150;
	logic [10:0] win_size_x = 104;
	logic [10:0] win_size_y = 34;
	
	logic [9:0] X_Pos, Y_Pos;
	
	logic is_white, is_red, is_win;
	white(.Clk, .read_address((DrawX-X_Pos)+(DrawY-Y_Pos)*160), .data_Out(is_white));
	red(.Clk, .read_address((DrawX-X_Pos)+(DrawY-Y_Pos)*160), .data_Out(is_red));
	win(.Clk, .read_address((DrawX-X_Pos)+(DrawY-Y_Pos)*104), .data_Out(is_win));
	
	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk) begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end
	
	always_ff @ (posedge Clk)
	begin
		if(Reset)
		begin
			winner = 0;
			X_Pos <= X_Center;
			Y_Pos <= Y_Center;
		end
		else
		begin
			X_Pos <= X_Pos;
			Y_Pos <= Y_Pos;
		end
	end
	
	always_comb
	begin
		if(score1 != 10 && score2 != 10)
		begin
			is_end = 0;
		end
		else if(DrawX >= X_Pos && DrawX < X_Pos + size_x && DrawY >= Y_Pos && DrawY < Y_Pos + size_y)
		begin
			if(score1 == 10)
				is_end = is_white;
			else if(score2 == 10)
				is_end = is_red;
			else
				is_end = 0;
		end
		else if(DrawX >= win_center_x && DrawX < win_center_x + win_size_x && DrawY >= win_center_y && DrawY < win_center_y + win_size_y)
		begin
			if(score1 == 10 || score2 == 10)
				is_end = is_win;
			else
				is_end = 0;
		end
		else 
		begin
			is_end = 0;
		end
	end
	
endmodule
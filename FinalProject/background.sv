module background(
			input Clk, Reset, frame_clk,
			input is_title,
			input [9:0] DrawX, DrawY,
			output logic [2:0] is_back
			);
			
	 logic[2:0] color;
	 logic[10:0] x_size = 32;
	 logic[10:0] y_size = 32;
	 
	 logic [2:0] rock;
	 logic [2:0] block;
	 rock(.Clk, .read_address((DrawX % x_size)+(DrawY % y_size)*x_size), .data_Out(rock));
	 block(.Clk, .read_address((DrawX % x_size) + (DrawY - y_size)*x_size), .data_Out(block));
	 
	 logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	 
	 always_comb
	 begin
		if(DrawY >= 364 && DrawY < 396)
			is_back = block;
		else if(DrawY >= 396 && DrawY < 480)
			is_back = rock;
		else
			is_back = 0;
	 end

endmodule
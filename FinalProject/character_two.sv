module  character_two ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					input         left, right, punch, kick, hurt, enter,
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input			  is_title,
               output logic  [1:0] is_char,             // Whether current pixel belongs to ball or background
					output logic  punching, kicking,
					output logic  [9:0]  position
              );
    logic [10:0] X_Center = 450;
	 logic [10:0] Y_Center = 316;
	 logic [10:0] shape_size_x = 32;
	 logic [10:0] shape_size_y = 48;
	 logic [10:0] X_min = 10'd0;
	 logic [10:0] X_max = 10'd600;
	 logic [10:0] X_Step = 10'd1;
	 
	 logic [9:0] X_Pos, X_Motion, Y_Pos, Y_Motion;
    logic [9:0] X_Pos_in, X_Motion_in, Y_Pos_in, Y_Motion_in;
	 
	 logic [1:0] walk1_color, walk2_color;
	 walk1 walk1_sprite(.Clk, .read_address(32-(DrawX-X_Pos)+((DrawY-Y_Pos)*32)), .data_Out(walk1_color));
	 walk2 walk2_sprite(.Clk, .read_address(32-(DrawX-X_Pos)+((DrawY-Y_Pos)*32)), .data_Out(walk2_color));
	 
	 logic [1:0] in_punch, in_kick;
	 logic [1:0] walk3_color, punch_color, kick_color, hit_color;
	 walk3 walk3_sprite(.Clk, .read_address(32-(DrawX-X_Pos)+((DrawY-Y_Pos)*32)), .data_Out(walk3_color));
	 punch punch_sprite(.Clk, .read_address(32-(DrawX-X_Pos)+((DrawY-Y_Pos)*32)), .data_Out(punch_color));
	 lowkick kick_sprite(.Clk, .read_address(32-(DrawX-X_Pos)+((DrawY-Y_Pos)*32)), .data_Out(kick_color));
	 hit hit_sprite(.Clk, .read_address(32-(DrawX-X_Pos)+((DrawY-Y_Pos)*32)), .data_Out(hit_color));
	 attack_ani punch_control(.Clk(frame_clk_rising_edge), .Reset, .keypress(punch), .ani(in_punch));
	 attack_ani kick_control(.Clk(frame_clk_rising_edge), .Reset, .keypress(kick), .ani(in_kick));
	 
	 logic done;	 
	 
	 logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	 
	 always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            X_Pos <= X_Center;
            Y_Pos <= Y_Center;
            X_Motion <= 0;
            Y_Motion <= 0;
				done <= 0;
        end
		  else if(enter)
		  begin
				X_Pos <= X_Center;
            Y_Pos <= Y_Center;
            X_Motion <= 0;
            Y_Motion <= 0;
				done <= 0;
		  end
		  else if(hurt)
		  begin
				X_Pos <= X_Pos_in;
				Y_Pos <= Y_Pos_in;
				X_Motion <= 0;
				Y_Motion <= 0;
				done <= 1;
		  end
        else
        begin
            X_Pos <= X_Pos_in;
            Y_Pos <= Y_Pos_in;
            X_Motion <= X_Motion_in;
            Y_Motion <= Y_Motion_in;
				done <= done;
        end
    end
	 
	 always_comb
	 begin:find_motion
		X_Pos_in = X_Pos;
		Y_Pos_in = Y_Pos;
		X_Motion_in = 0;
		Y_Motion_in = 0;
		
		if(frame_clk_rising_edge)
		begin
			if(in_punch > 0)
			begin
			end
			else if(in_kick > 0)
			begin
			end
			else if(done)
			begin
			end
			else if(left == 1'b1)
			begin
				if(X_Pos - 10'd10 <= X_min)
					X_Motion_in = 0;
				else
					X_Motion_in = ~(X_Step) + 1'b1;
			end
			else if(right == 1'b1)
			begin
				if(X_Pos + 10'd10 >= X_max)
					X_Motion_in = 0;
				else
					X_Motion_in = X_Step;
			end
			X_Pos_in = X_Pos + X_Motion_in;
		end
	end
	 
    always_comb
	 begin:Proc
		punching = 0;
		kicking = 0;
		if(is_title == 1'b1)
		begin
			is_char = 2'b0;
		end
		else if(DrawX >= X_Pos && DrawX < X_Pos + shape_size_x && DrawY >= Y_Pos && DrawY < Y_Pos + shape_size_y)
		begin
			if(done)
				is_char = hit_color;
			else if(in_punch == 2)
			begin
				is_char = punch_color;
				punching = 1;
			end
			else if(in_kick == 2)
			begin
				is_char = kick_color;
				kicking = 1;
			end
			else if(in_punch == 1 || in_kick == 1)
				is_char = walk3_color;
			else if((X_Pos - X_Center) % 16 < 8)
				is_char = walk1_color;
			else
				is_char = walk2_color;
		end
		else
		begin
			is_char = 2'b0;
		end
	end
	assign position = X_Pos;
endmodule
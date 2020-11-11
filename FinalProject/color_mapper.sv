module  color_mapper ( input              [1:0] is_char2,            // Whether current pixel belongs to ball 
							  input					[1:0] is_char1,
							  input					is_title,
							  input					[2:0] is_back,
							  input 					is_win,
                                                              //   or background (computed in ball.sv)
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
    // Assign color based on is_ball signal
    always_comb
    begin
		  if(is_title == 1'b1)
		  begin
				Red = 8'hff;
				Green = 8'h00;
				Blue = 8'h00;
		  end
		  else if(is_win)
		  begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
		  end
		  else if (is_char1 == 2'b01) 
        begin
            Red = 8'hfc;
            Green = 8'hfc;
            Blue = 8'hfc;
        end
		  else if(is_char1 == 2'b10)
		  begin
				Red = 8'hfc;
				Green = 8'h98;
				Blue = 8'h38;
		  end
		  else if(is_char1 == 2'b11)
		  begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'h00;
		  end
		  else if(is_char2 == 2'b01)
		  begin
				Red = 8'hc2;
            Green = 8'h00;
            Blue = 8'h00;
		  end
		  else if(is_char2 == 2'b10)
		  begin
				Red = 8'hfc;
				Green = 8'h98;
				Blue = 8'h38;
		  end
		  else if(is_char2 == 2'b11)
		  begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'h00;
		  end
		  else if(is_back == 1)
		  begin
				Red = 8'h7c;
				Green = 8'h08;
				Blue = 8'h00;
		  end
		  else if(is_back == 2)
		  begin
				Red = 8'h82;
				Green = 8'h80;
				Blue = 8'h00;
		  end
		  else if(is_back == 3)
		  begin
				Red = 8'hfc;
				Green = 8'h74;
				Blue = 8'h60;
		  end
		  else if(is_back == 4)
		  begin
				Red = 8'hfc;
				Green = 8'hbc;
				Blue = 8'hb0;
		  end
        else
        begin
            Red = 8'h3c; 
            Green = 8'hbc;
            Blue = 8'hfc;
        end
    end 
    
endmodule
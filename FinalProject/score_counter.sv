module score_counter(
							input logic Clk,
							input logic [3:0] inscore1,
							input logic [3:0] inscore2,
							input logic Reset,
							input logic enter,
							
							input logic hit1,
							input logic hit2,
							
							output logic [3:0] outscore1,
							output logic [3:0] outscore2,
							output logic complete
							
							);
							
	enum logic [3:0] {
		start, point1, point2, win1, win2, reset, hold
	} curr_state, next_state;
	logic [3:0] score1, score2;
	always_ff @ (posedge Clk)
	begin
		if(Reset)
			curr_state = reset;
		else
			curr_state = next_state; 
	end
	
	always_ff @ (posedge Clk)
	begin
		score1 = inscore1;
		score2 = inscore2;
		complete = 0;
		next_state = curr_state;
		unique case (curr_state)
			start:
			begin
				if(hit1 && hit2)
					next_state = start;
				else if(hit1)
					next_state = point2;
				else if(hit2)
					next_state = point1;
				else
					next_state = start;
			end
			
			point1:
			begin
				if(score1 == 10)
					next_state = win1;
				else
				begin
					score1 = inscore1 + 1;
					next_state = hold;
				end
			end
			
			point2:
			begin
				if(score2 == 10)
					next_state = win2;
				else
				begin
					score2 = inscore2 + 1;
					next_state = hold;
				end
			end
			hold:
			begin
				if(enter)
				begin
					next_state = start;
				end
				else
					next_state = hold;
			end
			win1:
			begin
				next_state = win1;
				complete = 1;
			end
			 win2:
			begin
				next_state = win2;
				complete = 1;
			end
			reset:
			begin
				score1 = 0;
				score2 = 0;
				next_state = start;
			end
		endcase
	end
	
	assign outscore1 = score1;
	assign outscore2 = score2;
endmodule
	
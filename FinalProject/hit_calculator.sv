module hit_calculator(
		input logic [9:0] x1, x2,
		input logic punch1, punch2, kick1, kick2,
		input logic high1, high2, low1, low2,
		output logic hit1, hit2
		);
		
	
	always_comb
	begin
		hit1 = 0;
		hit2 = 0;
		if((x2-x1) <= 28)
		begin
			if((punch1&&kick2) && (punch2&&kick1))
			begin
				hit1 = 1;
				hit2 = 1;
			end
			else if(punch1)
			begin
				if(punch2 || high2)
				begin end
				else
					hit2 = 1;
			end
			else if(punch2)
			begin
				if(punch1 || high1)
				begin end
				else
					hit1 = 1;
			end
			else if(kick1)
			begin
				if(kick2 || low2)
				begin end
				else
					hit2 = 1;
			end
			else if(kick2)
			begin
				if(kick1 || low1)
				begin end
				else hit1 = 1;
			end
		end
	end
endmodule
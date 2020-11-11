module branch_logic(
	input logic[2:0] cc,
	input logic n,z,p, LD_BEN,
	output logic match
	);
	
	always_comb
	begin
		if(LD_BEN)
		begin
			if(cc[2] == 1'b1 && n == 1'b1)
				match <= 1;
			else if(cc[1] == 1'b1 && z == 1'b1)
				match <= 1;
			else if(cc[0] == 1'b1 && p == 1'b1)
				match <= 1;
			else
				match <= 0;
		end
		else
			match <= 0;
	end
endmodule
		
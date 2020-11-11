module end_game(
		input logic [3:0] score1, score2,
		output logic one_win, two_win
		);

	always_comb
	begin
		one_win = 0;
		two_win = 0;
		if(score1 == 5)
			one_win = 1;
		else if(score2 == 5)
			two_win = 2;
	end
endmodule
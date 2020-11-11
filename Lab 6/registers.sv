module register (input logic[15:0] regIn,
						input logic Clk, Load, Reset,
						output logic[15:0] regOut
						);
						

	always_ff @ (posedge Clk)
	begin
		if(Reset == 0)
			regOut <= 16'h0000;
		if(Load)
			regOut<= regIn;
		else
			regOut <= regOut;
	end
endmodule
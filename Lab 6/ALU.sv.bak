module ALU (
				
				input logic [15:0] A, B,
				input logic [1:0] ALUK,
				
				output logic [15:0] out
				
				);
				
	always_comb
	begin
		
		// ADD if ALUK is 00
		if (ALUK == 2'b00)
			out <= A + B;
		// AND if ALUK is 01
		else if (ALUK == 2'b01)
			out <= A & B;
		
		// NOT if ALUK is 10
		else if (ALUK == 2'b10)
			out <= ~A;
		
		// Let A pass through otherwise
		else
			out <= A;
	
	end
	
	endmodule
	
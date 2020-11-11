module adder(
	input logic[15:0] A,B,
	output logic[15:0] out
	);
	
	always_comb
	begin
		out = A + B;
	end
endmodule
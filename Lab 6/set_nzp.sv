module set_nzp(
	input logic [15:0] in,
	output logic n,z,p
	);
	
	always_comb
	begin
		n = 0;
		z = 0;
		p = 0;
		if(in[15] == 1)
			n = 1;
		else if(in == 16'b0)
			z = 1;
		else
			p = 1;
	end
endmodule
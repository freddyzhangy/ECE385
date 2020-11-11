module extend
	#(parameter width = 16)
	 (input logic [width-1: 0] in,
	 input logic sign,
	 output logic [15:0] out
	 );
	 
	 always_comb
	 begin
		for(int i = 0; i < 16; i++)
		begin
			if(i < width)
				out[i] = in[i];
				
			if(sign == 1)
				out[i] = in[width-1];
			else
				out[i] = 1'b0;
		end
	end
	
endmodule

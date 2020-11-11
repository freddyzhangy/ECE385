module four_one_MUX(
				input logic [15:0] A, B, C, D,
				input logic [1:0]select,
				
				output logic [15:0] out
				
				);
				
	always_comb
	begin
		
		case(select)
			
			2'b00: out <= A;
			
			2'b01: out <= B;
			
			2'b10: out <= C;
			
			2'b11: out <= D;
		
		endcase
			
	end
	
endmodule

module two_one_MUX(
			input logic [15:0] A,B,
			input logic select,
			output logic [15:0] out
			);
			
	always_comb
	begin
		
		case(select)
			1'b0: out <= A;
			1'b1: out <= B;
		endcase
	end
	
endmodule


module three_bit_MUX(
			input logic [2:0] A, B,
			input logic select,
			output logic [2:0] out
			);
	always_comb
	begin
		
		case(select)
			1'b0: out <= A;
			1'b1: out <= B;
		endcase
	end
endmodule
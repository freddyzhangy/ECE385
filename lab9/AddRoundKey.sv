module AddRoundKey(
	
	input logic CLK,
	input logic [127:0] msg,
	input logic [10:0][127:0] key,
	input logic [4:0] round,
	output logic [127:0] out
	
	);
	
	logic [127:0] roundkey, roundkey_n;
	
	always_comb
	
	begin
		case(round)
		
			5'b0000:
			begin
				roundkey_n = key[1];
			end
			
			5'b0001:
			begin
				roundkey_n = key[2];
			end
			
			5'b0010:
			begin
				roundkey_n = key[3];
			end
			
			5'b0011:
			begin
				roundkey_n = key[4];
			end
			
			5'b0100:
			begin
				roundkey_n = key[5];
			end
			
			5'b0101:
			begin
				roundkey_n = key[6];
			end
			
			5'b0110:
			begin	
				roundkey_n = key[7];
			end
			
			5'b0111:
			begin
				roundkey_n = key[8];
			end
			
			5'b1000:
			begin
				roundkey_n = key[9];
			end
			
			5'b1001:
			begin
				roundkey_n = key[10];
			end
			
			5'b1010:
			begin
				roundkey_n = key[0];
			end
			default:
			begin
				roundkey_n = 128'h0;
			end
		
		endcase
		
	end
	
	always_ff @ (posedge CLK)
	begin
		
		roundkey <= roundkey_n;
		
	end
	
	always_comb
	begin
		
		for(int i = 0; i < 128; i++)
		begin
			out[i] = msg[i] ^ roundkey[i]; 
		end
		
	end
	
endmodule
module AddRoundKey(

	input logic [127:0] msg,
	input logic [1407:0] key,
	input logic [4:0] round,
	output logic [127:0] out
	);
	
	logic [127:0] roundkey;
	
	always_comb
	begin
		case(round)
		
			5'b0000:
			begin
				roundkey = key[1407:1280];
			end
			
			5'b0001:
			begin
				roundkey = key[1279:1152];
			end
			
			5'b0010:
			begin
				roundkey = key[1151:1024];
			end
			
			5'b0011:
			begin
				roundkey = key[1023:896];
			end
			
			5'b0100:
			begin
				roundkey = key[895:768];
			end
			
			5'b0101:
			begin
				roundkey = key[767:640];
			end
			
			5'b0110:
			begin	
				roundkey = key[639:512];
			end
			
			5'b0111:
			begin
				roundkey = key[511:384];
			end
			
			5'b1000:
			begin
				roundkey = key[383:256];
			end
			
			5'b1001:
			begin
				roundkey = key[255:128];
			end
			
			5'b1010:
			begin
				roundkey = key[127:0];
			end
			default: // Not sure about this, fixed an error!
			begin
				roundkey = 128'h0;
			end
		
		endcase
		
		out = msg ^ roundkey;
		
	end
endmodule
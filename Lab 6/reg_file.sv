module reg_file (
		input logic[15:0] registerIn [7:0],
		input logic[15:0] regIn,
		input logic[2:0] SR1, DR, SR2,
		input logic Clk, Load,
		
		output logic[15:0] SR1_out, SR2_out,
		output logic[15:0] register [7:0]);
		
		
	always_comb
	begin
		for(int i = 0; i<8; i++)
		begin
			register[i] = registerIn[i];
		end
		case(SR1)
			3'b000: SR1_out = register[0];
			3'b001: SR1_out = register[1];
			3'b010: SR1_out = register[2];
			3'b011: SR1_out = register[3];
			3'b100: SR1_out = register[4];
			3'b101: SR1_out = register[5];
			3'b110: SR1_out = register[6];
			3'b111: SR1_out = register[7];
		endcase
		case(SR2)
			3'b000: SR2_out = register[0];
			3'b001: SR2_out = register[1];
			3'b010: SR2_out = register[2];
			3'b011: SR2_out = register[3];
			3'b100: SR2_out = register[4];
			3'b101: SR2_out = register[5];
			3'b110: SR2_out = register[6];
			3'b111: SR2_out = register[7];
		endcase
		if(Load) //Load vs ~Load
		begin
			case(DR)
				3'b000: register[0] = regIn;
				3'b001: register[1] = regIn;
				3'b010: register[2] = regIn;
				3'b011: register[3] = regIn;
				3'b100: register[4] = regIn;
				3'b101: register[5] = regIn; 
				3'b110: register[6] = regIn;
				3'b111: register[7] = regIn;
			endcase
		end
	end
endmodule
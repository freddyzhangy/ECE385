// 00: roundkey
// 01: shiftrows
// 10: subbytes
// 11: mixcolumns

module AES_Control(

	input logic CLK,
	input logic RESET,
	input logic AES_START,
	output logic AES_DONE,
	output logic [4:0] counter,
	output logic [1:0]op_out, wd_out

);

//	Enumerating states
	enum logic[3:0]{
	
		Start, ARK, ISR, ISB, IMC1, IMC2, IMC3, IMC4, Stop, halted
	
	} curr_state, next_state;
	
//	Counter used to hold the Iteration count
	logic [4:0] CTR;
	
	always_ff @ (posedge CLK)
	begin
		if(RESET)
		begin
			curr_state <= Start;
		end
		else
		begin
			curr_state <= next_state;
			if(curr_state == Start)
				CTR = 0;
			else if(curr_state == ARK)
				CTR <= CTR + 1;
		end
	end
	
	
	always_comb
	begin
		
		next_state = curr_state;
		
		unique case (curr_state)
			
//			Stay at Start unless AES_START is Active
			Start:
			begin
						if (AES_START)
						begin
							next_state = ARK;
						end
						else
						begin
							next_state = Start;
						end
			end
			
//			If in one of the first few iterations, continue
			ARK:
			begin
						if (CTR == 5'd00)
						begin
							next_state = ISR;
						end
//						If final round
						else if (CTR == 5'd11)
						begin
							next_state = Stop;
						end
						else
						begin
							next_state = IMC1;
						end
			end
						
//			InvShiftRows
			ISR:		next_state = ISB;
			
//			InvSubBytes
			ISB:		next_state = ARK;
			
//			InvMixColumns step 1
			IMC1:		next_state = IMC2;
			
//			InvMixColumns step 2	
			IMC2:		next_state = IMC3;
			
//			InvMixColumns step 3
			IMC3:		next_state = IMC4;

//			InvMixColumns step 4
			IMC4:		next_state = ISR;
			
//			Last Round
			Stop:
			begin
				next_state = halted;
			end
			
//			End of computation
			halted:
			begin
				if(AES_START)
						begin
							next_state = halted;
						end
						else
						begin
							next_state = Start;
						end	
			end	
			
		endcase
		
	
		AES_DONE = 1'b0;
		op_out = 2'bzz;
		wd_out = 2'bzz;
		
		case(curr_state)
			
			Start:	begin end
			
//			Checking if we reached the end of the rounds (9th rounds)
			ARK:
			begin			
//						temp = CTR + 1;
//						if (CTR != 11)
//						begin
//							CTR_Out = CTR + 1;
//						end
						
//			op_out is set to operation 00 - > AddRoundKey
						op_out = 2'b00;
			end
			
//			op_out is set to operation 01 - > InvShiftRows
			ISR:		op_out = 2'b01;
			
//			op_out is set to operation 10 - > InvSubBytes
			ISB:		op_out = 2'b10;
			
//			op_out is set to operation 11 - > InvMixColumns
//			since MixColumns works different on different Rows, selecting rowss using wd_out
			IMC1:
			begin
						op_out = 2'b11;
						wd_out = 2'b00;
			end
			
			IMC2:
			begin
						op_out = 2'b11;
						wd_out = 2'b01;
			end
			
			IMC3:
			begin
						op_out = 2'b11;
						wd_out = 2'b10;
			end
			
			IMC4:		
			begin
						op_out = 2'b11;
						wd_out = 2'b11;
			end
			
			Stop: begin end

//			Done with rounds
			halted:		AES_DONE = 1'b1;
		
		endcase

	
	end
	
	assign counter = CTR;
	

endmodule

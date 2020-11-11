// 00: roundkey
// 01: shiftrows
// 10: subbytes
// 11: mixcolumns

module AES_Control(

	input logic CLK,
	input logic RESET,
	input logic AES_START,
	output logic AES_DONE,
	output logic [4:0] CTR,
	output logic [1:0]op_out, wd_out

);

//	Enumerating states
	enum logic[3:0]{
	
		Start, KE, ARK, ISR, ISB, ARK_M, IMC1, IMC2, IMC3, IMC4, ISR_Done, ISB_Done, ARK_Done, Done
	
	} curr_state, next_state;
	
	logic [4:0] CTR_next;
	logic AES_DONE_next;
	
	always_ff @ (posedge CLK)
	begin
		
		if(RESET)
		begin
			
			curr_state = Start;
			CTR = 5'b0;
			
		end
		else
		begin
			
			curr_state = next_state;
			CTR = CTR_next;
			
		end
		
	end
	
	
	always_comb
	begin
		
		next_state = curr_state;
		CTR_next = CTR;
		
		AES_DONE_next = AES_DONE;
		op_out = 2'bzz;
		wd_out = 2'bzz;
		
		case (curr_state)
		
			Start:begin
						
						if(AES_START)
							next_state = KE;
						CTR_next = 5'b0;
						
					end
					
			KE:	begin
					
					if (CTR == 5'd10)
					begin
					
						next_state = ARK;
					
					end
					
					CTR_next = CTR + 5'd1;
					
					end
				
			ARK:	begin
					
					next_state = ISR;
					op_out = 2'b00;
					CTR_next = 5'b0;
					
					end
					
			ISR:	begin
			
					next_state = ISB;
					op_out = 2'b01;
					
					end
					
			ISB:	begin
				
					next_state = ARK_M;
					op_out = 2'b10;
					
					end
					
			ARK_M:begin
					
						next_state = IMC1;
						op_out = 2'b00;
						
					end
			
			IMC1:	begin
					
						next_state = IMC2;
						op_out = 2'b11;
						wd_out = 2'b00;
					
					end

			IMC2:	begin
						
						next_state = IMC3;
						op_out = 2'b11;
						wd_out = 2'b01;
						
					end

			IMC3:	begin
						
						next_state = IMC4;
						op_out = 2'b11;
						wd_out = 2'b10;
						
					end

			IMC4:	begin
						
						next_state = (CTR == 5'd8)? ISR_Done : ISR;
						CTR_next = CTR + 5'd1;
						op_out = 2'b11;
						wd_out = 2'b11;
						
					end

			ISR_Done:	
					begin
						
						next_state = ISB_Done;
						op_out = 2'b01;
						
					end
					
			ISB_Done:
					begin
						
						next_state = ARK_Done;
						op_out = 2'b10;
						
					end
			
			ARK_Done:
					begin
						
						next_state = Done;
						op_out = 2'b00;
						AES_DONE_next = 1'b1;
						
					end
					
			Done:	begin
						
						if(~AES_START)
						begin
							
							next_state = Start;
							AES_DONE_next = 1'b0;
							
						end
						
					end
					
			default:
					begin
					end
			
			endcase
	
	end
	
	assign AES_DONE = AES_DONE_next;

endmodule

////		next_state = curr_state;
//		
//		unique case (curr_state)
//			
////			Stay at Start unless AES_START is Active
//			Start:
//			begin
//						if (AES_START)
//						begin
//							next_state = ARK;
//						end
//						else
//						begin
//							next_state = Start;
//						end
//			end
//			
////			If in one of the first few iterations, continue
//			ARK:
//			begin
//						if (CTR == 5'd00)
//						begin
//							next_state = ISR;
//						end
////						If final round
//						else if (CTR == 5'd11)
//						begin
//							next_state = Stop;
//						end
//						else
//						begin
//							next_state = IMC1;
//						end
//			end
//						
////			InvShiftRows
//			ISR:		next_state = ISB;
//			
////			InvSubBytes
//			ISB:		next_state = ARK;
//			
////			InvMixColumns step 1
//			IMC1:		next_state = IMC2;
//			
////			InvMixColumns step 2	
//			IMC2:		next_state = IMC3;
//			
////			InvMixColumns step 3
//			IMC3:		next_state = IMC4;
//
////			InvMixColumns step 4
//			IMC4:		next_state = ISR;
//			
////			Last Round
//			Stop:
//			begin
//				next_state = halted;
//			end
//			
////			End of computation
//			halted:
//			begin
//				if(AES_START)
//						begin
//							next_state = halted;
//						end
//						else
//						begin
//							next_state = Start;
//						end	
//			end	
//			
//		endcase
//		
//	
//		AES_DONE = 1'b0;
//		CTR_Out = CTR;
//		op_out = 2'bzz;
//		wd_out = 2'bzz;
//		
//		case(curr_state)
//			
//			Start:	CTR_Out = 5'b0;
//			
////			Checking if we reached the end of the rounds (9th rounds)
//			ARK:
//			begin			
//						if (CTR != 11)
//						begin
//							CTR_Out = CTR + 1;
//						end
//						
////			op_out is set to operation 00 - > AddRoundKey
//						op_out = 2'b00;
//			end
//			
////			op_out is set to operation 01 - > InvShiftRows
//			ISR:		op_out = 2'b01;
//			
////			op_out is set to operation 10 - > InvSubBytes
//			ISB:		op_out = 2'b10;
//			
////			op_out is set to operation 11 - > InvMixColumns
////			since MixColumns works different on different Rows, selecting rowss using wd_out
//			IMC1:
//			begin
//						op_out = 2'b11;
//						wd_out = 2'b00;
//			end
//			
//			IMC2:
//			begin
//						op_out = 2'b11;
//						wd_out = 2'b01;
//			end
//			
//			IMC3:
//			begin
//						op_out = 2'b11;
//						wd_out = 2'b10;
//			end
//			
//			IMC4:		
//			begin
//						op_out = 2'b11;
//						wd_out = 2'b11;
//			end
//			
//			Stop: begin end
//
////			Done with rounds
//			halted:		AES_DONE = 1'b1;
//		
//		endcase
//	
//	
//	end
//	
//	
//


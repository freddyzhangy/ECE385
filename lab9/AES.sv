/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/
// 00: roundkey
// 01: shiftrows
// 10: subbytes
// 11: mixcolumns

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);

	logic [10:0][127:0] KS;
	logic [127:0] RoundKeyOut, ShiftRowsOut, InvSubOut, Bus;
	logic [7:0] SubBytesOut;
	logic [31:0] MixColsOut, MixColsIn;
	logic [4:0] CTR;
	logic [1:0] op_out, wd_out;
	
//	Initializing the fsm
	AES_Control states(.CLK, .RESET, .AES_START, .AES_DONE, .CTR, .op_out, .wd_out);
	
//	Setting up the Key Schedule
	KeyExpansion KE1(.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(KS));
	
//	Step 1 - AddRoundKey
	AddRoundKey roundkey(.CLK, .msg(Bus), .key(KS), .round(CTR), .out(RoundKeyOut));
	
//	Starting the Loop x 9

//	Shifting Rows
	InvShiftRows shiftrows(.data_in(AES_MSG_DEC), .data_out(ShiftRowsOut));
	InvMixColumns mixcolumns(.in(MixColsIn), .out(MixColsOut));
	
//	InvSubBytes
	InvSubHelper InvSub1(.clk(CLK), .in(Bus[127:96]), .out(InvSubOut[127:96]));
	InvSubHelper InvSub2(.clk(CLK), .in(Bus[95:64]), .out(InvSubOut[95:64]));
	InvSubHelper InvSub3(.clk(CLK), .in(Bus[63:32]), .out(InvSubOut[63:32]));
	InvSubHelper InvSub4(.clk(CLK), .in(Bus[31:0]), .out(InvSubOut[31:0]));
	
	always_ff @ (posedge CLK)
	
	begin
		if(RESET)
		begin
			Bus = AES_MSG_ENC;
		end
		if(op_out == 2'b00)
		begin
			Bus = RoundKeyOut;
			MixColsIn = Bus[31:0];
		end
		
		if(op_out == 2'b01)
		begin
			Bus = ShiftRowsOut;
		end
		
		if(op_out == 2'b10)
		begin
			Bus = InvSubOut;
		end
		
		if(op_out == 2'b11)
		begin
			if(wd_out == 2'b00)
			begin
			
//				MixColsIn = Bus[31:0];
				Bus[31:0] = MixColsOut;
				MixColsIn = Bus[63:32];
				
			end
			else if(wd_out == 2'b01)
			begin
				
				Bus[63:32] = MixColsOut;
				MixColsIn = Bus[95:64];
				
				
			end
			else if(wd_out == 2'b10)
			begin
				
				Bus[95:64] = MixColsOut;
				MixColsIn = Bus[127:96];
				
			end
			else if(wd_out == 2'b11)
			begin
				
				Bus[127:96] = MixColsOut;
				
			end
		end
		
	end
	assign AES_MSG_DEC = Bus;
//	assign counter = CTR;
	
endmodule

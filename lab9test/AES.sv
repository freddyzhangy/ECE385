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
	output logic [127:0] AES_MSG_DEC,
	output logic [63:0] key
);

	logic [1407:0] KS;
	logic [127:0] RoundKeyOut, ShiftRowsOut, InvSubOut, msg;
	logic [7:0] SubBytesOut;
	logic [31:0] MixColsOut, MixColsIn;
	logic [4:0] CTR;
	logic [1:0] op_out, wd_out;
	
	KeyExpansion KE1(.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(KS));
	AES_Control states(.CLK, .RESET, .AES_START, .AES_DONE, .counter(CTR), .op_out, .wd_out);
	AddRoundKey roundkey(.msg(msg), .key(KS), .round(CTR), .out(RoundKeyOut));
	InvShiftRows shiftrows(.data_in(msg), .data_out(ShiftRowsOut));
	InvMixColumns mixcolumns(.in(MixColsIn), .out(MixColsOut));
	
	InvSubHelper InvSub1(.clk(CLK), .in(msg[127:96]), .out(InvSubOut[127:96]));
	InvSubHelper InvSub2(.clk(CLK), .in(msg[95:64]), .out(InvSubOut[95:64]));
	InvSubHelper InvSub3(.clk(CLK), .in(msg[63:32]), .out(InvSubOut[63:32]));
	InvSubHelper InvSub4(.clk(CLK), .in(msg[31:0]), .out(InvSubOut[31:0]));
	
	// addroundkey
	always_ff @ (posedge CLK)
	begin
		if(op_out == 2'b00)
		begin
			msg = RoundKeyOut;
		end
		
		if(op_out == 2'b01)
		begin
			msg = ShiftRowsOut;
		end
		
		if(op_out == 2'b10)
		begin
			msg = InvSubOut;
		end
		
		if(op_out == 2'b11)
		begin
			if(wd_out == 2'b00)
			begin
				msg[31:0] = MixColsOut;
				MixColsIn = msg[63:32];
			end
			else if(wd_out == 2'b01)
			begin
				msg[63:32] = MixColsOut;
				MixColsIn = msg[95:64];
			end
			else if(wd_out == 2'b10)
			begin
				msg[95:64] = MixColsOut;
				MixColsIn = msg[127:96];
			end
			else if(wd_out == 2'b11)
			begin
				msg[127:96] = MixColsOut;
			end
			else
			begin
				MixColsIn = msg[31:0];
			end
		end
		
	end
	
	assign AES_MSG_DEC = msg;
	assign key = KS[63:0];
endmodule

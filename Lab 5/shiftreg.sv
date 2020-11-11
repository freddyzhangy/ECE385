
module shift_reg (						// shifts AB register right one bit

	input logic [7:0] A,
	input logic [7:0] B,
	input logic [7:0] in,
	input logic Clk, Shift_En, Load_En, Clr_En,
	
	output logic[7:0] A_out,
	output logic[7:0] B_out,
	output logic shifted

);
	logic [7:0] Ashift, Bshift, Aload, Bload;
	
	bit_shift shiftB (.Shift_In(A[0]), .in(B), .Data_Out(Bshift));
			 
	bit_shift shiftA (.Shift_In(A[7]), .in(A), .Data_Out(Ashift));

	always_ff @ (posedge Clk)
    begin
	 shifted <= 1'b0;
	 
		 if(Clr_En)
		 begin
			 if(Load_En)
					B_out = in;
			 A_out = 8'b00000000;	
		 end
		 
		 else if(Shift_En)
		 begin
			  B_out = Bshift; 
			  A_out = Ashift;
			  shifted <= 1'b1;
	    end
		 
		 else
		 begin
			A_out = A;
			B_out = B;
		 end	 
		 
			
    end
	
	
	logic nothing;	
endmodule


module bit_shift (input logic Shift_In,
				  input  logic [7:0] in, 
				  
              output logic [7:0]  Data_Out);

    assign Data_Out = {Shift_In, in[7:1]};

endmodule



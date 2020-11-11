module multiplier (
	input logic[7:0] A,
	input logic[7:0] B,
	input logic[7:0] switch,
	input Clk, Add_En, Sub_En, LdB,
	
	output logic[7:0] A_out,
	output logic[7:0] B_out, subbed,
	output logic 		x, added);
	
	logic[8:0] sum, diff;
	logic[7:0] S_sub;
	
	inverter notSwitch(.in(switch), .out(S_sub));
	adder add(.A, .B(switch), .cin(0), .Sum(sum));
	adder sub(.A, .B(S_sub), .cin(1), .Sum(diff));
	
	always_comb
	begin
		added <= 1'b0;
		subbed <= 8'b0;
		if(Add_En & B[0])
		begin
			A_out <= sum[7:0];
			x <= sum[8];
			B_out <= B;
			added <= 1'b1;
		end
		else if(Sub_En == 1'b1 && B[0] == 1'b1)
		begin
			A_out <= diff[7:0];
			x <= diff[8];
			B_out <= B;
			subbed <= diff[7:0];
		end
		else
		begin
			A_out <= A;
			x <= A[7];
			B_out <= B;
		end
	end
endmodule

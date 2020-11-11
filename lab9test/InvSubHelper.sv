module InvSubHelper(
		input logic clk,
		input logic [31:0] in,
		output logic [31:0] out
		);

	InvSubBytes sub1(.clk, .in(in[31:24]), .out(out[31:24]));
	InvSubBytes sub2(.clk, .in(in[23:16]), .out(out[23:16]));
	InvSubBytes sub3(.clk, .in(in[15:8]), .out(out[15:8]));
	InvSubBytes sub4(.clk, .in(in[7:0]), .out(out[7:0]));

endmodule
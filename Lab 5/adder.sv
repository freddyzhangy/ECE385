module adder
(
    input   logic[7:0]     A,
    input   logic[7:0]     B,
	 input	logic				cin,

    output  logic[8:0]     Sum
);
	logic nothing, c1, c2, c3, c4, c5, c6, c7,c8;
	full_adder add0(.a(A[0]), .b(B[0]), .c(cin), .s(Sum[0]), .cout(c1));
	full_adder add1(.a(A[1]), .b(B[1]), .c(c1), .s(Sum[1]), .cout(c2));
	full_adder add2(.a(A[2]), .b(B[2]), .c(c2), .s(Sum[2]), .cout(c3));
	full_adder add3(.a(A[3]), .b(B[3]), .c(c3), .s(Sum[3]), .cout(c4));
	full_adder add4(.a(A[4]), .b(B[4]), .c(c4), .s(Sum[4]), .cout(c5));
	full_adder add5(.a(A[5]), .b(B[5]), .c(c5), .s(Sum[5]), .cout(c6));
	full_adder add6(.a(A[6]), .b(B[6]), .c(c6), .s(Sum[6]), .cout(c7));
	full_adder add7(.a(A[7]), .b(B[7]), .c(c7), .s(Sum[7]), .cout(c8));
	full_adder add8(.a(A[7]), .b(B[7]), .c(c8), .s(Sum[8]), .cout(nothing));
	    

     
endmodule

module full_adder
(
	input a,b,c,
	output s,cout
);

	assign s = a^b^c;
	assign cout = (a&b)|(b&c)|(a&c);

endmodule

module inverter
(
	input logic[7:0] in,
	output logic[7:0] out
);
	assign out[0] = in[0]^1'b1;
	assign out[1] = in[1]^1'b1;
	assign out[2] = in[2]^1'b1;
	assign out[3] = in[3]^1'b1;
	assign out[4] = in[4]^1'b1;
	assign out[5] = in[5]^1'b1;
	assign out[6] = in[6]^1'b1;
	assign out[7] = in[7]^1'b1;
	
endmodule
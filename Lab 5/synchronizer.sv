module sync (
	input  logic Clk, d, 
	output logic q
);

always_ff @ (posedge Clk)
begin
	q <= d;
end

endmodule


module flipflop (
	input logic Clk,
	input logic[7:0] in,
	
	output logic[7:0] out
);

always_ff @ (posedge Clk)
begin
	out <= in;
end
endmodule

/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  lowkick
(
		input [1535:0] read_address,
		input Clk,

		output logic [1:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [3:0] mem [0:1535];

initial
begin
	 $readmemh("sprite_bytes/low.txt", mem);
end

//always_comb
//begin
//	data_Out = mem[read_address];
//end
always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule

//module colorPalette( input logic[15:0] DRAM_DQ,
//							input logic[2:0]what,
//							output logic [7:0] sprite_r, sprite_g, sprite_b
//							);
//	
//	logic [7:0] colordata = (sprite_x[0] == 1)? SRAM_DQ[15:8] : SRAM_DQ[7:0];
//	
//	always_comb
//	begin
//		unique case(colordata)
//		8'hFF:
//		begin
//		end
//		endcase
//	end
//endmodule
module busMUX(
	input logic GateALU, GateMDR, GateMARMUX, GatePC,
	input logic[15:0] MARMUX, PC, ALU, MDR, busIn,
	output logic[15:0] bus);
	
	always_comb
	begin
		if(GateALU)
			bus = ALU;
		else if(GateMDR)
			bus = MDR;
		else if(GateMARMUX)
			bus = MARMUX;
		else if(GatePC)
			bus = PC;
		else
			bus = busIn;
	end
endmodule
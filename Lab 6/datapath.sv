module datapath(
						input logic Reset, Clk, Run, 
						input logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED,
						input logic GatePC, GateMDR, GateALU, GateMARMUX,
						input logic [1:0] PCMUX, ADDR2MUX, ALUK,
						input logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX,
						input logic MIO_EN,
						input logic [15:0] MDR_In, IR, PC, S,
						
						output logic BEN,
						output logic [15:0] IR_out, MDR, MAR, PC_out
					
					);
					
	logic[15:0] register[7:0];
	logic[15:0] PCreg;
	logic[15:0] value, bus, addr1, addr2, addr_out, ALU_out;
	logic[2:0] DR, SR1, SR2;
	logic[15:0] SR1_out, SR2_out, SR2MUX_out, Mioen_out;
	logic n,z,p;
	
	logic[15:0] sext11, sext9, sext6, sext5;
	
	reg_file registerfile(.registerIn(register), .regIn(bus), .SR1, .SR2, .DR, .Clk, .Load(LD_REG), .SR1_out, .SR2_out, .register);

	extend #(11) sign11(.in(IR[10:0]), .sign(IR[10]), .out(sext11));
	extend #(9) sign8(.in(IR[8:0]), .sign(IR[8]), .out(sext9));
	extend #(6) sign6(.in(IR[5:0]), .sign(IR[5]), .out(sext6));
	extend #(5) sign5(.in(IR[4:0]), .sign(IR[4]), .out(sext5));
	
	four_one_MUX addr2mux(.A(sext11), .B(sext9), .C(sext6), .D(16'b0), .select(ADDR2MUX), .out(addr2));
	four_one_MUX pcmux(.A(bus), .B(addr_out), .C(PC+1'b1), .D(PCreg), .select(PCMUX), .out(PCreg));
	
	two_one_MUX addr1mux(.A(SR1_out), .B(PC), .select(ADDR1MUX), .out(addr1));
	two_one_MUX sr2mux(.A(SR2_out), .B(sext5), .select(SR2MUX), .out(SR2MUX_out));
	two_one_MUX mioen(.A(bus), .B(MDR_In), .select(MIO_EN), .out(Mioen_out));
	
	three_bit_MUX drmux(.A(3'b111), .B(IR[11:9]), .select(DRMUX), .out(DR));
	three_bit_MUX sr1mux(.A(IR[11:9]), .B(IR[8:6]), .select(SR1MUX), .out(SR1));
	
	ALU alu(.A(SR1_out), .B(SR2MUX_out), .ALUK, .out(ALU_out));
	
	set_nzp setcc(.in(bus), .n, .z, .p);
	
	branch_logic branch(.cc(IR[11:9]), .n, .z, .p, .LD_BEN, .match(BEN));
	
	adder add(.A(addr2), .B(addr1), .out(addr_out));
	
	busMUX BUSMUX(.busIn(bus), .GateALU, .GatePC, .GateMARMUX, .GateMDR, .ALU(ALU_out), .MDR(Mioen_out), .MARMUX(addr_out), .PC(PC), .bus);
	// add, addi, and, andi, not, br, jmp, jsr, ldr, str, pause
	// load value in reg into value
	
	
	
	always_ff @ (posedge Clk)
	begin
		IR_out <= IR;
		MDR <= MDR;
		MAR <= MAR;
		PC_out <= PC_out;
		if(Reset == 0)
		begin
			PC_out <= 16'h0000;
			MAR <= 16'h0000;
			MDR <= 16'h0000;
			IR_out <= 16'h0000;
		end
		if(LD_MAR)
			MAR <= bus;
		if(LD_PC)
			PC_out <= PCreg;
		if(LD_MDR)
			MDR <= Mioen_out;
		if(LD_IR)
			IR_out <= bus;
	end
//

////		else if(GatePC == 1 && LD_MAR == 1 && LD_PC == 1)
////		begin
////			MAR <= PC;
////			PC_out <= PC + 1;
////		end
////		
////		else if(LD_MDR == 1 && MIO_EN == 1)
////		begin
////			MDR <= Mioen_out;
////		end
////		else if(GateMDR == 1 && LD_IR == 1)
////		begin
////			IR_out <= MDR;
////		end
//	end	
	
	
	
endmodule

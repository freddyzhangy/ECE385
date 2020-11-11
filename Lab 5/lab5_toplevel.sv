module lab5_toplevel
(
    input   logic           Clk,        // 50MHz clock is only used to get timing estimate data
    input   logic           Reset,      // From push-button 0.  Remember the button is active low (0 when pressed)
    input   logic           ClearA_LoadB,   // From push-button 1
    input   logic           Run,        // From push-button 3.
    input   logic[7:0]      S,         // From slider switches
    
    // all outputs are registered
    output  logic           X,
    output  logic[6:0]      AhexL,      
    output  logic[6:0]      AhexU,
    output  logic[6:0]      BhexL,
    output  logic[6:0]      BhexU,
	 output  logic[7:0]      A_out, B_out
);

    /* Declare Internal Registers */
    logic[7:0]     A, B, Asum_out, Bsum_out;
	 
	 
	 logic Shift_En, Add_En, Sub_En, Load_En, Clr_En;
	 logic Reset_sync, Run_sync, Load_sync;
    
    /* Declare Internal Wires
     * Wheather an internal logic signal becomes a register or wire depends
     * on if it is written inside an always_ff or always_comb block respectivly */

								
	 control ctrl(			.Clk(Clk), 
								.Reset(Reset_sync),
								.Execute(Run_sync),
								.Shift_En(Shift_En), 
								.LoadB(Load_sync),
								.Add_En,
								.Sub_En,
								.Load_En,
								.Clr_En);
								
	 multiplier multi(	.A(A),
								.B(B),
								.switch(S),
								.Add_En,
								.Sub_En,
								.Clk(Clk),
								
								.A_out(Asum_out),
								.B_out(Bsum_out),
								.x(X));
								
	 shift_reg shift(		.A(Asum_out),
								.B(Bsum_out),
								.in(S),
								.Clk,
								.Shift_En,
								.Load_En,
								.Clr_En,
								.A_out(A),
								.B_out(B));
								
    assign A_out = A;
	 assign B_out = B;
	 					  
    HexDriver AhexU_inst
    (
        .In0(A[3:0]),   // This connects the 4 least significant bits of 
                        // register A to the input of a hex driver named Ahex0_inst
        .Out0(AhexU)
    );
    
    HexDriver AhexL_inst
    (
        .In0(A[7:4]),
        .Out0(AhexL)
    );

    HexDriver BhexU_inst
    (
        .In0(B[3:0]),
        .Out0(BhexU)
    );
    
    HexDriver BhexL_inst
    (
        .In0(B[7:4]),
        .Out0(BhexL)
    );
    
    sync syncRun (.Clk, .d(Run), .q(Run_sync) );
	 sync syncReset (.Clk, .d(Reset), .q(Reset_sync) );
	 sync syncLoad (.Clk, .d(ClearA_LoadB), .q(Load_sync) );
endmodule

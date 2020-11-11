module keycode_reader(
								input logic [31:0] keycode,
								
								output logic a_on, d_on, g_on, h_on,			// Player 1
								output logic l_on, r_on, one_on, two_on,	// Player 2
								output logic enter_on

								);

//	Player 1 Controls

//Left Movement
	assign a_on = (keycode[31:24] == 8'h04 |
	 
	keycode[23:16] == 8'h04 |
	 
	keycode[15: 8] == 8'h04 |
	 
	keycode[ 7: 0] == 8'h04); 

//Right Movement
	assign d_on = (keycode[31:24] == 8'h07 |
 
	keycode[23:16] == 8'h07 |
	 
	keycode[15: 8] == 8'h07 |
	 
	keycode[ 7: 0] == 8'h07);
		
//Attack 1		
	assign g_on = (keycode[31:24] == 8'h0a |
	 
	keycode[23:16] == 8'h0a |
	 
	keycode[15: 8] == 8'h0a |
	 
	keycode[ 7: 0] == 8'h0a); 
	
//Attack 2
	assign h_on = (keycode[31:24] == 8'h0b |
	 
	keycode[23:16] == 8'h0b |
	 
	keycode[15: 8] == 8'h0b |
	 
	keycode[ 7: 0] == 8'h0b); 
	
////high block
//	assign w_on = (keycode[31:24] == 8'h1a |
//	 
//	keycode[23:16] == 8'h1a |
//	
//	keycode[15: 8] == 8'h1a |
//	 
//	keycode[ 7: 0] == 8'h1a); 
//	
////low block
//	assign s_on = (keycode[31:24] == 8'h16 |
//	 
//	keycode[23:16] == 8'h16 |
//	
//	keycode[15: 8] == 8'h16 |
//	 
//	keycode[ 7: 0] == 8'h16); 
	
//	Player 2 Controls

//Left Movement
	assign l_on = (keycode[31:24] == 8'h50 |
	 
	keycode[23:16] == 8'h50 |
	 
	keycode[15: 8] == 8'h50 |
	 
	keycode[ 7: 0] == 8'h50); 
	
//Right Movement	
	assign r_on = (keycode[31:24] == 8'h4F |
 
	keycode[23:16] == 8'h4F |
	 
	keycode[15: 8] == 8'h4F |
	 
	keycode[ 7: 0] == 8'h4F);
	
//Attack 1							
	assign one_on = (keycode[31:24] == 8'h59 |
	 
	keycode[23:16] == 8'h59 |
	 
	keycode[15: 8] == 8'h59 |
	 
	keycode[ 7: 0] == 8'h59); 

//Attack 2
	assign two_on = (keycode[31:24] == 8'h5a |
	 
	keycode[23:16] == 8'h5a |
	 
	keycode[15: 8] == 8'h5a |
	 
	keycode[ 7: 0] == 8'h5a); 
	
////high block
//	assign up_on = (keycode[31:24] == 8'h52 |
//	 
//	keycode[23:16] == 8'h52 |
//	
//	keycode[15: 8] == 8'h52 |
//	 
//	keycode[ 7: 0] == 8'h52); 
//	
////low block
//	assign down_on = (keycode[31:24] == 8'h51 |
//	 
//	keycode[23:16] == 8'h51 |
//	
//	keycode[15: 8] == 8'h51 |
//	 
//	keycode[ 7: 0] == 8'h51); 
	
//Enter
	assign enter_on = (keycode[31:24] == 8'h28 | 
	
	keycode[23:16] == 8'h28 |
	
	keycode[15:8] == 8'h28  |
	
	keycode[7:0]  == 8'h28  );
endmodule	
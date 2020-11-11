module audio_controller(
								
									output logic [15:0]  LDATA, RDATA,
									output logic Init, 
									input	logic Init_Finish, Reset, Clk, data_over,
									input logic frame_clk
								
								);
								
enum logic [1:0] {Start} state,next_state;
								
always_comb
	begin	
	unique case(state)
		Start:
		begin
		next_state<=Start;
		end
	endcase
end	

always_ff @ (posedge Clk or posedge Reset)
	begin
	
		if ( Reset ) 
			begin 
				LDATA <= 16'hFFFF;
				RDATA <= 16'hFFFF;
				state<= Start;
			end
		else
			begin
	
		state <= next_state;

			if(Init_Finish)
				begin
//Need to add some logic for inputting .wav here+
				end
				else
				begin
					Init <= Init;
					LDATA <= LDATA;
					RDATA <= RDATA;
				end
			end
		
	end
endmodule

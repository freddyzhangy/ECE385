//Two-always example for state machine

module control (input  logic Clk, Reset, Execute, LoadB,
                output logic Shift_En, Add_En, Sub_En, Load_En, Clr_En, inA);

    // Declare signals curr_state, next_state of type enum
    // with enum values of A, B, ..., F as the state values
	 // Note that the length implies a max of 8 states, so you will need to bump this up for 8-bits
    enum logic [5:0] {A, A_clr, B_add, B_shift, C_add, C_shift, D_add, D_shift, E_add, E_shift, F_add, F_shift, G_add, G_shift, H_add, H_shift, I_sub, I_shift, J}   curr_state, next_state; 

	//updates flip flop, current state is the only one
    always_ff @ (posedge Clk)  
    begin
        if (Reset)
            curr_state <= A;
        else 
            curr_state <= next_state;
    end

    // Assign outputs based on state
	always_comb
    begin
        next_state = curr_state;
        unique case (curr_state) 
			
            A :    if (Execute)
                         next_state = A_clr;
								 
				A_clr   :    next_state = B_add;							  
            B_add   :    next_state = B_shift;
            B_shift :    next_state = C_add;
				
				C_add   :    next_state = C_shift;
            C_shift :    next_state = D_add;
				
				D_add   :    next_state = D_shift;
            D_shift :    next_state = E_add;
				
				E_add   :    next_state = E_shift;
            E_shift :    next_state = F_add;
				
				F_add   :    next_state = F_shift;
            F_shift :    next_state = G_add;
				
				G_add   :    next_state = G_shift;
            G_shift :    next_state = H_add;
				
				H_add   :    next_state = H_shift;
            H_shift :    next_state = I_sub;
				  
				I_sub   :    next_state = I_shift;
            I_shift :    next_state = J;
								
				J :	 if (~Execute) 
                       next_state = A;
						 else
							  next_state = J;
        endcase
   
		  // Assign outputs based on ‘state’
		  Add_En = 1'b0;
		  Sub_En = 1'b0;
		  Shift_En = 1'b0;
		  Load_En = 1'b0;
		  Clr_En = 1'b0;
        case (curr_state) 
	   	   A: 
	         begin 
					Load_En = LoadB;
					Clr_En = LoadB;
		      end
				A_clr:
				begin
					Clr_En = 1'b1;
				end
				B_add, C_add, D_add, E_add, F_add, G_add, H_add:
				begin
					Add_En = 1'b1;
				end
				B_shift, C_shift, D_shift, E_shift, F_shift, G_shift, H_shift, I_shift:
				begin
					Shift_En = 1'b1;;
				end
				I_sub:
				begin
					Sub_En = 1'b1;
				end
	   	   J: 
		      begin
               Shift_En = 1'b0;
					Add_En = 1'b0;
					Sub_En = 1'b0;
					Load_En = 1'b0;
		      end
				default: 
				begin
					Add_En = 1'b0;
					Sub_En = 1'b0;
					Shift_En = 1'b0;
					Load_En = 1'b0;
				end	
        endcase
		  if(curr_state == A)
			inA = 1'b1;
			else 
				inA = 1'b0;
    end

endmodule

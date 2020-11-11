module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

logic clk;

always begin : CLOCK_GENERATION
#1 clk = ~clk;
end

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.

initial begin: CLOCK_INITIALIZATION
    clk = 0;
end 

logic CLK;
logic RESET;
logic AES_START;
logic AES_DONE;
logic [127:0] AES_KEY;
logic [127:0] AES_MSG_ENC;
logic [127:0] AES_MSG_DEC;
//logic [31:0] counter;

assign CLK = clk;

// Instantiating the DUT
// Make sure the module and signal names match with those in your design
AES ae(.*);

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS

AES_KEY = 128'h000102030405060708090a0b0c0d0e0f;
RESET = 1;
AES_START = 0;
AES_MSG_ENC = 128'hdaec3055df058e1c39e814ea76f6747e;
#4
RESET = 0;
#2
AES_START = 1;

end
endmodule

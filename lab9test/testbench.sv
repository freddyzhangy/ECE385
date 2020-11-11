module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.

logic CLOCK_50, AVL_READ, AVL_WRITE, AVL_CS;
logic [1:0] KEY;
logic [3:0] AVL_BYTE_EN, AVL_ADDR;
logic [31:0] AVL_WRITEDATA, AVL_READDATA, EXPORT_DATA;

// Instantiating the DUT
// Make sure the module and signal names match with those in your design
lab9_top toplevel(.*);	

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 CLOCK_50 = ~CLOCK_50;
end

initial begin: CLOCK_INITIALIZATION
    CLOCK_50 = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
#2 KEY[1] = 1;
#2 KEY[1] = 0;
#3
#1 AVL_WRITE = 1;
AVL_CS = 1;
#1
AVL_BYTE_EN = 0;
AVL_ADDR = 0;
AVL_WRITEDATA = 2'hFF;
#1
AVL_BYTE_EN = 2;
AVL_ADDR = 0;
AVL_WRITEDATA = 2'hFF;
#1
AVL_BYTE_EN = 1;
AVL_ADDR = 0;
AVL_WRITEDATA = 2'hFF;
#1
AVL_BYTE_EN = 3;
AVL_ADDR = 0;
AVL_WRITEDATA = 2'hFF;
end
endmodule

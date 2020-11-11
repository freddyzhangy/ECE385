/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/
//this is a test to see if the ip gets updated 

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);

	logic [31:0] registers[15:0];
	logic done;
	logic [127:0] decode;
	logic [31:0] counter;
	logic [63:0] key;
	
	always_ff @ (posedge CLK)
	begin
		if(RESET)
		begin
			for(int i = 0; i < 16; i++)
			begin
				registers[i] <= 0;
			end
		end
		else if(AVL_WRITE && AVL_CS)
		begin
			if(AVL_BYTE_EN[3])
			begin
				registers[AVL_ADDR][31:24] <= AVL_WRITEDATA[31:24];
			end
			if(AVL_BYTE_EN[2])
			begin
				registers[AVL_ADDR][23:16] <= AVL_WRITEDATA[23:16];
			end
			if(AVL_BYTE_EN[1])
			begin
				registers[AVL_ADDR][15:8] <= AVL_WRITEDATA[15:8];
			end
			if(AVL_BYTE_EN[0])
			begin
				registers[AVL_ADDR][7:0] <= AVL_WRITEDATA[7:0];
			end
		end
		else
		begin
			registers[15] <= done;
			registers[8] <= decode[31:0];
			registers[9] <= decode[63:32];
			registers[10] <= decode[95:64];
			registers[11] <= decode[127:96];
			registers[12] <= key[63:0];
		end
	end
	
	assign AVL_READDATA = (AVL_CS && AVL_READ) ? registers[AVL_ADDR] : 32'b0; // reverse order
	assign EXPORT_DATA[15:0] = registers[3][15:0];
	assign EXPORT_DATA[31:16] = registers[0][31:16];
	AES aes(.CLK, .RESET, .AES_START(registers[14]), .AES_DONE(done), .AES_KEY({registers[0], registers[1], registers[2], registers[3]}),
			  .AES_MSG_ENC({registers[4], registers[5], registers[6], registers[7]}),
			  .AES_MSG_DEC(decode), .key);

endmodule

/************************************************************************
Lab 9 Quartus Project Top Level

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module lab9_top (
	input  logic        CLOCK_50,
	input  logic [1:0]  KEY,
	input  logic AVL_READ, AVL_WRITE, AVL_CS,
	input  logic [3:0] AVL_BYTE_EN, AVL_ADDR,
	input  logic [31:0] AVL_WRITEDATA,
	output logic [31:0] AVL_READDATA,
	output logic [31:0] EXPORT_DATA
);

avalon_aes_interface aes_interface(
	.CLK(CLOCK_50),
	.RESET(KEY[1]),
	.EXPORT_DATA,
	.AVL_READ,
	.AVL_WRITE,
	.AVL_CS,
	.AVL_BYTE_EN,
	.AVL_ADDR,
	.AVL_WRITEDATA,
	.AVL_READDATA
	);
	


// Exported data to show on Hex displays
logic [31:0] AES_EXPORT_DATA;

// Instantiation of Qsys design

// Display the first 4 and the last 4 hex values of the received message
hexdriver hexdrv0 (
	.In(AES_EXPORT_DATA[3:0]),
   .Out(HEX0)
);
hexdriver hexdrv1 (
	.In(AES_EXPORT_DATA[7:4]),
   .Out(HEX1)
);
hexdriver hexdrv2 (
	.In(AES_EXPORT_DATA[11:8]),
   .Out(HEX2)
);
hexdriver hexdrv3 (
	.In(AES_EXPORT_DATA[15:12]),
   .Out(HEX3)
);
hexdriver hexdrv4 (
	.In(AES_EXPORT_DATA[19:16]),
   .Out(HEX4)
);
hexdriver hexdrv5 (
	.In(AES_EXPORT_DATA[23:20]),
   .Out(HEX5)
);
hexdriver hexdrv6 (
	.In(AES_EXPORT_DATA[27:24]),
   .Out(HEX6)
);
hexdriver hexdrv7 (
	.In(AES_EXPORT_DATA[31:28]),
   .Out(HEX7)
);

endmodule


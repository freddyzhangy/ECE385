
/************************************************************************
Lab 9 Nios Software
Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013
For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x00000040;

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;

/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *  
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */
char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *  
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}

// Helper Functions

unsigned char SubBytes(unsigned char input)

{

	return aes_sbox[input];
}

unsigned char InvSubBytes(unsigned char input)

{
	return aes_invsbox[input];
}


unsigned char RotWord(unsigned char * word)

{

	unsigned char temp = word[0];

	word[0] = word[1];
	word[1] = word[2];
	word[2] = word[3];
	word[3] = temp;

	return *word;
}

void keyExpansion(unsigned char * key, unsigned char * key_schedule)
{

		unsigned char prevword[4];

		int wordCount,i,j;

		for(i = 0; i < 16; i++){

			key_schedule[i] = key[i];

		}
//		for(int a = 0; a < 4; a++){
//			for(int b = 0; b < 4; b++){
//				key_schedule[b*4 + a] = key[a*4 + b];
//			}
//		}

		i = 16;

		while(i < 176){

			for(j = 0; j < 4; j++){

				prevword[j] = key_schedule[i + j - 4];

			}

			if(i % 16 == 0){

				RotWord(prevword);


				for(wordCount = 0; wordCount < 4; wordCount++){

					prevword[wordCount] = SubBytes(prevword[wordCount]);

				}


				prevword[0] ^= Rcon[(i/16)] >> 24;
//				for(int j = 0; j < sizeof(prevword); j++)
//										printf("%x ", prevword[j]);
				//printf("%x, %x\n", prevword[0], Rcon[(i/16)] >> 24);

			}

			for(j = 0; j < 4; j++){

				key_schedule[i] = key_schedule[i - 16] ^ prevword[j];
				i++;

			}

		}
}

void AddRoundKey(unsigned char *message, unsigned char *key, int ct)
{
	unsigned char adjust[16];

//	printf("\n roundkey \n");
	for(int j = 0; j < 16; j++){
		adjust[j] = key[ct*16 + j];
	}
	unsigned char temp;
	for(int j = 0; j < 4; j++){
		for(int k = 0; k < 4; k++){
			if(j > k)
				continue;
			temp = adjust[k+j*4];
			adjust[k+j*4] = adjust[j+k*4];
			adjust[j+k*4] = temp;
		}
	}
//	for(int j = 0; j < 16; j++){
//		if(j%4 == 0)
//			printf("\n");
//		printf("%x ", adjust[j]);
//	}
	int i = 0;

	for (i = 0; i < 16; i++)
		message[i] ^= adjust[i];

	//printf("\n");

//	unsigned char temp;
//	for(int j = 0; j < 4; j++){
//		for(int k = 0; k < 4; k++){
//			printf("%x ", message[k+j*4]);
//		}
//		printf("\n");
//	}
//	printf("\n before");

//	for(int j = 0; j < 4; j++){
//		for(int k = 0; k < 4; k++){
//			if(j > k)
//				continue;
//			temp = message[k+j*4];
//			message[k+j*4] = message[j+k*4];
//			message[j+k*4] = temp;
//		}
//	}

//	printf("\n after\n");
//	for(int j = 0; j < 4; j++){
//			for(int k = 0; k < 4; k++){
//				printf("%x ", message[k+j*4]);
//			}
//			printf("\n");
//		}
}

void ShiftRows(unsigned char * message)
{

	unsigned char temp = 0;
	int i = 0;

	for (i = 0; i < 4; i++)
	{
		switch(i){

			case 0:break;

			case 1: temp = message[i * 4];
					message[i * 4] = message[(i * 4) + 1];
					message[(i * 4) + 1] = message[(i * 4) + 2];
					message[(i * 4) + 2] = message[(i * 4) + 3];
					message[(i * 4) + 3] = temp;
					break;

			case 2: temp = message[i * 4];
					message[i *4] = message[(i * 4) + 2];
					message[(i * 4) + 2] = temp;
					temp = message[(i * 4) + 1];
					message[(i * 4) + 1] = message[(i * 4) + 3];
					message[(i * 4) + 3] = temp;
					break;

			case 3: temp = message[i * 4];
					message[i * 4] = message[(i * 4) + 3];
					message[(i * 4) + 3] = message[(i * 4) + 2];
					message[(i * 4) + 2] = message[(i * 4) + 1];
					message[(i * 4) + 1] = temp;
					break;

			default:continue;
		}
	}
}

void InvShiftRows(unsigned char * message)
{

	unsigned char temp;
	int i = 0;

	for (i = 0; i < 4; i++)
	{
		switch(i){

			case 0:break;

			case 1: temp = message[i * 4];
					message[i * 4] = message[(i * 4) + 3];
					message[(i * 4) + 3] = message[(i * 4) + 2];
					message[(i * 4) + 2] = message[(i * 4) + 1];
					message[(i * 4) + 1] = temp;
					break;

			case 2: temp = message[i * 4];
					message[i *4] = message[(i * 4) + 2];
					message[(i * 4) + 2] = temp;
					temp = message[(i * 4) + 1];
					message[(i * 4) + 1] = message[(i * 4) + 3];
					message[(i * 4) + 3] = temp;
					break;

			case 3: temp = message[i * 4];
					message[i * 4] = message[(i * 4) + 1];
					message[(i * 4) + 1] = message[(i * 4) + 2];
					message[(i * 4) + 2] = message[(i * 4) + 3];
					message[(i * 4) + 3] = temp;
					break;

			default:continue;
		}
	}
}
unsigned char xtime(unsigned char a){
	unsigned int clear = 0x00FF;
	unsigned int offset = 0x001B;
	unsigned int needxor = 0;
	if((a&0x80) != 0)
		needxor = 1;
	unsigned char out = (a << 1)&clear;
	if(needxor == 1){
		//printf("\n offset for %x \n", a);
		out = out ^ offset;
	}
	return out;
}
void MixColumns(unsigned char * message)
{
	unsigned char temp[16] = {0};
	unsigned char a,b,c,d;
	int i = 0;

	for (i = 0; i < 4; i++)
	{
		for(int k = 0; k < 4; k++){
			switch(i){
			case 0:
				a = xtime(message[k]);
				b = xtime(message[k+4]) ^ message[k+4];
				c = message[k+8];
				d = message[k+12];
				break;
			case 1:
				a = message[k];
				b = xtime(message[k+4]);
				c = xtime(message[k+8]) ^ message[k+8];
				d = message[k+12];
				break;
			case 2:
				a = message[k];
				b = message[k+4];
				c = xtime(message[k+8]);
				d = xtime(message[k+12]) ^ message[k+12];
				break;
			case 3:
				a = xtime(message[k]) ^ message[k];
				b = message[k+4];
				c = message[k+8];
				d = xtime(message[k+12]);
			}
			temp[k+4*i] = a^b^c^d;
		}
	}
	for(i = 0; i < 16; i++){
		message[i] = temp[i];
	}

}

void InvMixColumns(unsigned char * message)
{

//	unsigned char temp[16];
//	int i = 0;
//
//	for (i = 0; i < 16; i++)
//		temp[i] = message[i];
//
//	i = 0;
//
//	for (i = 0; i < 16; i++)
//	{
//
//		switch(i%4){
//
//			case 0:	message[i] = gf_mul[temp[i]][0] ^ gf_mul[temp[i + 1]][1] ^ temp[i + 2] ^ temp[i + 3];
//					break;
//			case 1: message[i] = temp[i - 1] ^ gf_mul[temp[i]][0] ^ gf_mul[temp[i + 1]][1] ^ temp[i + 2];
//					break;
//			case 2: message[i] = temp[i - 2] ^ temp[i - 1] ^ gf_mul[temp[i]][0] ^ gf_mul[temp[i + 1]][1];
//					break;
//			case 3: message[i] = gf_mul[temp[i - 3]][1] ^ temp[i - 2] ^ temp[i - 1] ^ gf_mul[temp[i]][0];
//		}
//	}
// 3 = 09, 4 = 0b, 5 = 0d, 6 = 0e
	unsigned char temp[16] = {0};
		unsigned char a,b,c,d;
		int i = 0;

		for (i = 0; i < 4; i++)
		{
			for(int k = 0; k < 4; k++){
				switch(i){
				case 0:
					a = gf_mul[temp[k]][6];
					b = gf_mul[temp[k+4]][4];
					c = gf_mul[temp[k+8]][5];
					d = gf_mul[temp[k+12]][3];
					break;
				case 1:
					a = gf_mul[temp[k]][3];
					b = gf_mul[temp[k+4]][6];
					c = gf_mul[temp[k+8]][4];
					d = gf_mul[temp[k+12]][5];
					break;
				case 2:
					a = gf_mul[temp[k]][5];
					b = gf_mul[temp[k+4]][3];
					c = gf_mul[temp[k+8]][6];
					d = gf_mul[temp[k+12]][4];
					break;
				case 3:
					a = gf_mul[temp[k]][4];
					b = gf_mul[temp[k+4]][5];
					c = gf_mul[temp[k+8]][3];
					d = gf_mul[temp[k+12]][6];
				}
				temp[k+4*i] = a^b^c^d;
			}
		}
		for(i = 0; i < 16; i++){
			message[i] = temp[i];
		}
}


/** encrypt
 *  Perform AES encryption in software.
 *
 *  Input: msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *         key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  Output:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *               key - Pointer to 4x 32-bit int array that contains the input key
 */
void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{
	// Implement this function


	unsigned char temp_message[16];
	unsigned char temp_key[16];

	int i = 0, j = 0;

	for(i = 0; i < 16; i++){
		temp_message[i] = charsToHex(msg_ascii[2 * i], msg_ascii[2 * i + 1]);
		temp_key[i] = charsToHex(key_ascii[2 * i], key_ascii[2 * i + 1]);
	}

	unsigned char temp;
	for(int j = 0; j < 4; j++){
		for(int k = 0; k < 4; k++){
			if(j > k)
				continue;
			temp = temp_message[k+j*4];
			temp_message[k+j*4] = temp_message[j+k*4];
			temp_message[j+k*4] = temp;
		}
	}

	unsigned char key_schedule[16*(10 + 1)];
	keyExpansion(temp_key, key_schedule);

	AddRoundKey(temp_message, key_schedule, 0);


	for(i = 0; i < 9; i++){

		for(j = 0; j < 16; j++)
			temp_message[j] = SubBytes(temp_message[j]);

		ShiftRows(temp_message);
		MixColumns(temp_message);
		AddRoundKey(temp_message, key_schedule, (i + 1));

	}

	for(j = 0; j < 16; j++){

			temp_message[j] = SubBytes(temp_message[j]);

	}

	ShiftRows(temp_message);

	AddRoundKey(temp_message, key_schedule, 10);

	for(int j = 0; j < 4; j++){
		for(int k = 0; k < 4; k++){
			if(j > k)
				continue;
			temp = temp_message[k+j*4];
			temp_message[k+j*4] = temp_message[j+k*4];
			temp_message[j+k*4] = temp;
		}
	}

	for(i = 0; i < 4; i++){

		msg_enc[i] = (temp_message[i * 4] << 24) + (temp_message[i * 4 + 1] << 16) + (temp_message[i * 4 + 2] << 8) + (temp_message[i * 4 + 3]);

		key[i] = (temp_key[i * 4] << 24) + (temp_key[i * 4 + 1] << 16) + (temp_key[i * 4 + 2] << 8) + (temp_key[i * 4 + 3]);

	}
}
/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	// Implement this function

//	Updating pointers to the key
	for(int i = 0; i < 8; i++){
		AES_PTR[i] = 0;
	}
	AES_PTR[0] = key[0];
	AES_PTR[1] = key[1];
	AES_PTR[2] = key[2];
	AES_PTR[3] = key[3];

//	Updating pointers to the message
	AES_PTR[4] = msg_enc[0];
	AES_PTR[5] = msg_enc[1];
	AES_PTR[6] = msg_enc[2];
	AES_PTR[7] = msg_enc[3];
//	AES_PTR[11] = 0xDEADBEEF;
//	if(AES_PTR[11] != 0xDEADBEEF)
//		printf("bad");
//	else
//		printf("good");
//	printf("\n%u = %u", AES_PTR[0], key[0]);
//	Setting AES_Start = 1
	AES_PTR[14] = 0x01;

//	Don't update decoded msg until operations completed
	while(1){
		printf("\ndecode?\n");
		for(int i = 8; i < 12; i++){
			printf("%x\n", AES_PTR[i]);
		}
		if(AES_PTR[15] == 0x01)
			AES_PTR[14] = 0;
		printf("counter: %x \n", AES_PTR[12]);
	}
//
////	Not sure about this, please check
	msg_dec[0] = AES_PTR[8];
	msg_dec[1] = AES_PTR[9];
	msg_dec[2] = AES_PTR[10];
	msg_dec[3] = AES_PTR[11];
////
//////	Setting AES_Start = 0
	AES_PTR[14] = 0x00;


}


/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33];
	unsigned char key_ascii[33];
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];

	printf("Select execution mode: 0 for testing, 1 for benchmarking: ");
	scanf("%d", &run_mode);

	if (run_mode == 0) {
		// Continuously Perform Encryption and Decryption
		while (1) {
			int i = 0;
			printf("\nEnter Message:\n");
			scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter Key:\n");
			scanf("%s", key_ascii);
			printf("\n");
			encrypt(msg_ascii, key_ascii, msg_enc, key);
			printf("\nEncrpted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			printf("\n");
			decrypt(msg_enc, msg_dec, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}

			printf("\n");
		}
	}
	else {
		// Run the Benchmark
		int i = 0;
		int size_KB = 2;
		// Choose a random Plaintext and Key
		for (i = 0; i < 32; i++) {
			msg_ascii[i] = 'a';
			key_ascii[i] = 'b';
		}
		// Run Encryption
		clock_t begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			encrypt(msg_ascii, key_ascii, msg_enc, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;
		printf("Software Encryption Speed: %f KB/s \n", speed);
		// Run Decryption
		begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			decrypt(msg_enc, msg_dec, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;
		printf("Hardware Encryption Speed: %f KB/s \n", speed);
	}
	return 0;
}

/**
* @class CSIS 165 - Assembly Language / Machine Architecture
* @author PA13-Solution
* @instructor Bochsler
* @assignment Week 13
* @date 04 May 2017
*
* @brief
* Implement functions for PA13 that combine pure Assembler Library and C/C++
*/
#include <stdio.h>
#include <stdint.h>
#include <string.h>

const char *decoderRing = "xpvgcfoaw qmykdtszbehijlnru";
const uint8_t DR_LEN = strlen(decoderRing);

extern "C" {
	/**
	* This function translates a plaintext input string (in) of length ilen
	* into a cipher text output string (out) via the use of an encoding based
	* on a decoderRing (ring).  The cipher text output is equivalent to the
	* offset of the first character of the input string, and each additional
	* character is the delta from the last character on the decoderRing.
	*
	*  @param [in] ring	String used for encryption
	*  @param [in] in		Plaintext string to be encrypted
	*  @param [out] out	Cyphertext string derived from ring and in
	*  @param [in] ilen	Length of plaintext string
	*  @param [in] ringlen Length of the string used for encryption
	*/
	void asmEncrypt(const char *ring, const char *in, char *out, int ilen, int8_t ringlen);
	/**
	* This function translates a cyphertext input string (in) of length ilen
	* into a cipher text output string (out) via the use of an encoding based
	* on a decoderRing (ring).  The cipher text output is equivalent to the
	* offset of the first character of the input string, and each additional
	* character is the delta from the last character on the decoderRing.
	*
	*  @param [in] ring	String used for encryption
	*  @param [in] in		Cyphertext string to be decrypted
	*  @param [out] out	Plaintext string derived from ring and in
	*  @param [in] ilen	Length of cyphertext string
	*  @param [in] ringlen Length of the string used for encryption
	*/
	void asmDecrypt(const char *ring, const char *in, char *out, int ilen, int8_t ringlen);
	/**
	* OPTIONAL function prototype that reflects my implementation.  You do NOT
	* have to use this
	*
	* This function returns the distance of input character c in the encryption
	* key ring (of length ringlen), starting from position start.
	*
	*  @param [in] ring	String used for encryption
	*  @param [in] in		Input character to search for in ring
	*  @param [in] start	Index in ring to start searching from.
	*  @param [in] ringlen Length of the string used for encryption
	*
	*  @retval 0-(ringlen-1)	Number of characters away that input c was found
	*  @retval -1				Character c was not found.
	*/
	int8_t asmFindFrom(const char *ring, char c, int8_t start, int8_t rlen);
}

static char *testStrings[] = {
	"",
	"abc",
	"aabcd",
	"abdefg",
	"ABCdefg",
	"bcdefgh",
	"abdefabcd",
	"abcdefgh",
	"abcabcabcda",
	"Test String",
	"tEST sTRING two",
	"Jenny Ive got your number",
	"Lucy in the sky with diamonds",
	"A man a plan a canal Panama",
	"Never odd or even"
};
#define NUM_TEST_CASES	(sizeof (testStrings) / sizeof (*testStrings))

static char eString[256], dString[256];

int main() {
	printf("CSIS-165 PA#13 Morgan\n");

	printf("\nEncrypt/decrypt with [%s]\n", decoderRing);
	for (int i = 0; i < NUM_TEST_CASES; i++) {

		int ilen = strlen(testStrings[i]);

		asmEncrypt(decoderRing, testStrings[i], eString, ilen, DR_LEN);
		asmDecrypt(decoderRing, eString, dString, ilen, DR_LEN);

		// print out the encrypted string, bytewise
		printf("[%s] => [", testStrings[i]);
		for (int i = 0; i < ilen; i++) {
			printf("%x ", eString[i]);
		}
		printf("] => [%s]\n", dString);
	}

	return 0;
}
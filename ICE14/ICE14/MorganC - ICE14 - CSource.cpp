/**
* @class CSIS 165 - Assembly Language / Machine Architecture
* @author ICE14-Solution
* @instructor Bochsler
* @assignment Week 14
* @date 5 May 2017
*
* @brief
* Implement functions for PA13 that combine pure Assembler Library and C/C++
*/
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <ctype.h>

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

#define NROWS	2
#define NCOLS	26
extern "C" {
	/**
	* Update the ASCII letter frequency array (fa) based on the occurances in string str.
	*
	*  @param [in] rcount	Row count of the frequency array.
	*  @param [in] ccount	Column count of the frequency array.
	*  @param [out] fa		ASCII letter frequency array
	*  @param [in] str		String used to augment the frequency array
	*/
	void asmUpdateFrequency(int rcount, int ccount, int16_t fa[NROWS][NCOLS], const char *str);
}

static int16_t letterFreq[NROWS][NCOLS] = { 0 };

static void
cMatrixPrint(int rcount, int ccount, int16_t matrix[NROWS][NCOLS])
{
	for (int r = 0; r < rcount; r++) {
		for (int c = 0; c < ccount; c++) {
			printf("%3d ", matrix[r][c]);
		}
		printf("\n");
	}
	printf("\n");
}


int main() {
	printf("CSIS-165 ICE#14 Morgan\n\n");

	// verify that the tracking vector is empty
	printf("ASCII letter frequency array before collecting data:\n");
	cMatrixPrint(NROWS, NCOLS, letterFreq);

	for (int i = 0; i < NUM_TEST_CASES; i++) {
#if 0
		// cUpdateFrequency(NROWS, NCOLS, letterFreq, testStrings[i]);
#else
		asmUpdateFrequency(NROWS, NCOLS, letterFreq, testStrings[i]);
#endif
	}
	printf("\n");

	printf("ASCII letter frequency array after collecting data:\n");

	// display the frequencies
	cMatrixPrint(NROWS, NCOLS, letterFreq);

	printf("\n");

	return 0;
}
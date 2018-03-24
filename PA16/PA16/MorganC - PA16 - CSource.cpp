/**
* @class CSIS 165 - Assembly Language / Machine Architecture
* @author PA16-Solution
* @instructor Bochsler
* @assignment Week 16
* @date 25 May 2017
*
* @brief
* Implement functions for PA16 that combine pure Assembler Library and C/C++
*/
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

extern "C" {
	/**
	* This function translates a input integer to a null terminated ASCII character string
	*
	*  @param [in] integer for conversion
	*  @param [in] char* to pre-allocated buffer to store the result
	*/
	void	intToBin(int32_t, char *);

	/**
	* This function returns true if the input string ss exists as a substring of the string s
	*
	*  @param [in] null terminated input string to be searched
	*  @param [in] null terminated string to be searched for
	*
	* @retval 0 - substring was not found
	* @retval 1 - substring was found
	*/
	bool	isSubString(const char *s, const char *ss);
}

static int32_t testData[] = {
	0x0,
	0xffeeeeff,
	0xdeadbeef,
	0xbaddf00d,
	0xd00fefac,
	0xfaceecaf,
	0xffffffff,
	0xaaaa5555,
	0x12345678
};
#define NUM_TEST_CASES	(sizeof (testData) / sizeof (testData[0]))

static char *testStrings2[] = { "",
"#",
"abc",
"abcd",
"abdefg",
"ABCdefg",
"bcdefgh",
"abdefabcd",
"abcdefgh",
"abcabcabcda",
};
#define NUM_TEST_CASES2	(sizeof (testStrings2) / sizeof (*testStrings2))

int main() {
	char	substr[] = "abcd";

	printf("CSIS-165 PA#16 Morgan\n");

	printf("\nProblem 1: Convert integer to a binary string\n");
	for (int i = 0; i < NUM_TEST_CASES; i++) {
		char	dest[33];
		intToBin(testData[i], dest);
		printf("intToBin(0x%8x) -> [%s]\n", testData[i], dest);
	}

	printf("\nProblem 2: Test for substring\n");
	for (int i = 0; i < NUM_TEST_CASES2; i++) {
		printf("isSubString(\"%s\", \"%s\") ? -> %s\n", testStrings2[i], substr,
			isSubString(testStrings2[i], substr) ? "true" : "false");
	}

	return 0;
}
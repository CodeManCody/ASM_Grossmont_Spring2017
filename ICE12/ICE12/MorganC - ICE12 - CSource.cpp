/**
* @class CSIS 165 - Assembly Language / Machine Architecture
* @author ICE12-Solution
* @instructor Bochsler
* @assignment Week 12
* @date20 Apr 2017
*
* @brief
* Implement functions for ICE9 that combine pure Assembler Library and C/C++
*/

#include <stdint.h>
#include <stdio.h>

extern "C" {

	int32_t findFirstChar(char *, char);
}

static char *testStrings[] = {
	"",
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
#define NUM_TEST_CASES	(sizeof (testStrings) / sizeof (*testStrings))
static char testChars[] = { 'c', 'd' };

int main()
{
	printf("CSIS-165 ICE#12 Morgan\n\n");

	//int f = findFirstChar(testStrings2[2], 'd');

	for (int i = 0; i < sizeof(testChars); i++) {
		char c = testChars[i];
		for (int j = 0; j < NUM_TEST_CASES; j++) {
			char *s = testStrings[j];
			printf("Char [%c] String [%s] offset [%d]\n", c, s, findFirstChar(s, c));
		}
		printf("\n");
	}

	return 0;
}
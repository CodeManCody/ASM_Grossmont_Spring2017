/**
* @class CSIS 165 - Assembly Language / Machine Architecture
* @author ICE8-Solution
* @instructor Bochsler
* @assignment Week 8
* @date 24 Mar 2017
*
* @brief
* Implement functions for ICE8 that combine pure Assembler Library and C/C++
*/

#include <stdint.h>
#include <stdio.h>
#include <string.h>

extern "C" {
	bool isStringEqual(const char *s1, const char *s2);
}

static char *testStrings[] = {
	"",
	"Test String 1",
	"Test String 2",
};
#define NUM_TEST_CASES	(sizeof (testStrings) / sizeof (char *))

int main()
{
	printf("CSIS-165 ICE#8 Morgan\n\n");

	for (int i = 0; i < NUM_TEST_CASES; i++) {
		printf("Input string [%s] [%s] yields: %s\n ", testStrings[i], testStrings[i],
			isStringEqual(testStrings[i], testStrings[i]) ? "true" : "false");
	}

	printf("Input string [%s] [%s] yields: %s\n ", testStrings[1], testStrings[2],
		isStringEqual(testStrings[1], testStrings[2]) ? "true" : "false");

	return 0;
}
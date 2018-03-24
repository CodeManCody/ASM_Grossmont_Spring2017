/**
* @class CSIS 165 - Assembly Language / Machine Architecture
* @author PA8-Solution
* @instructor Bochsler
* @assignment Week 8
* @date 30 Mar 2017
*
* @brief
* Implement functions for PA8 that combine pure Assembler Library and C/C++
*/

#include <stdint.h>
#include <stdio.h>
#include <string.h>

extern "C" {
	int32_t scanStringForChars(const char *s);
	int32_t stringLength(const char *s1);
	void stringReverse(const char *s1, char *s2);
}

static char *testStrings[] = { "",
"#",
"Test String 1",
"tEST sTRING 2",
"Jenny, I've got your number: 867-5309",
"Toto, we're not in \"Kansas\" anymore!",
"A man, a plan, a canal - Panama!",
"Never odd or even"
};
#define NUM_TEST_CASES	(sizeof (testStrings) / sizeof (char *))


int main()
{
	printf("CSIS-165 PA#8 Morgan\n\n");

	printf("\nProblem 1 output:\n");
	for (int i = 0; i < NUM_TEST_CASES; i++) {
		printf("Input string [%s] yields: ", testStrings[i]);
		scanStringForChars(testStrings[i]);
	}

	
	printf("\nProblem 2 output:\n");
	for (int i = 0; i < NUM_TEST_CASES; i++) {
		printf("Input string [%s] yields stringLength: %d\n", testStrings[i], stringLength(testStrings[i]));
	}

	
	printf("\nProblem 3 output:\n");

	/*
	MY C++ ROUGH EQUIVALENT

	string s1 = "hello";
	string s2;

	int s1_length = s1.length();
	int j = 0;

	for (int i = s1_length - 1; i >= 0; i--)
	{
		s2[j] = s1[i];
		j++;
	}
	*/

	
	for (int i = 0; i < NUM_TEST_CASES; i++) {
		char	tstring[256];
		stringReverse(testStrings[i], tstring);
		printf("Input string [%s] yields [%s]\n", testStrings[i], tstring);
	}
	
	

	printf("\n");

	return 0;
}
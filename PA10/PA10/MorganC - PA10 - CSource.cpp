/**
* @class CSIS 165 - Assembly Language / Machine Architecture
* @author PA10-Solution
* @instructor Bochsler
* @assignment Week 10
* @date 13 Apr 2017
*
* @brief
* Implement functions for PA10 that combine pure Assembler Library and C/C++
*/

#include <stdint.h>
#include <stdio.h>
#include <string.h>

extern "C" {
	int32_t isStringAPalindrome(const char *s);
}

static char *testStrings1[] = { "",
"#",
"Test String 1",
"tEST sTRING 2",
"Jenny, I've got your number: 867-5309",
"Toto, we're not in \"Kansas\" anymore!",
"A man, a plan, a canal - Panama!",
"Never odd or even",
"Nurses run!",
"Lewd did I live & evil I did dwel.",
"Norma is as selfless as I am, Ron."
};
#define NUM_TEST_CASES1	(sizeof (testStrings1) / sizeof (char *))

int main()
{
	char	substr[] = "abcd";

	printf("CSIS-165 PA#10 Morgan\n\n");
	
	printf("\nProblem 1 output:\n");
	for (int i = 0; i < NUM_TEST_CASES1; i++) {
		printf("Input string [%s] yields: %s\n", testStrings1[i],
			isStringAPalindrome(testStrings1[i]) ? "true" : "false");
	}
	

	printf("\n");

	return 0;
}
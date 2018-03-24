/**
* @class CSIS 165 - Assembly Language / Machine Architecture
* @author ICE11-Solution
* @instructor Bochsler
* @assignment Week 10
* @date 13 Apr 2017
*
* @brief
* Implement functions for ICE11 that combine pure Assembler Library and C/C++
*/

#include <stdint.h>
#include <stdio.h>

extern "C" {
	int32_t	asmGCD(int32_t a, int32_t b);
	int32_t	asmGCDR(int32_t a, int32_t b);
}

static int32_t testData[] = {
	0, 0,
	22, 44,
	23, 46,
	97, 541,
	1024, 931,
	512, 65536,
	15838, 15986,
	3899127, 27,
};
#define NUM_TEST_CASES	(sizeof (testData) / sizeof (*testData))

/* Standard C Function: Greatest Common Divisor */
static int32_t
gcd(int32_t a, int32_t b)
{
	while (a != 0) {
		int32_t c = a;
		a = b % a;
		b = c;
	}
	return b;
}

/* Recursive Standard C Function: Greatest Common Divisor */
static int
gcdr(int32_t a, int32_t b)
{
	return (a == 0) ? b : gcdr(b % a, a);
}


int main()
{
	printf("CSIS-165 ICE#11 Morgan\n\n");

	for (int i = 0; i < NUM_TEST_CASES; i += 2) {
		int32_t a = testData[i], b = testData[i + 1];

		printf("GCD(%4d,%4d) => GCDR(%d) asmGCDR(%d) GCD(%d) asmGCD(%d)\n",
			a, b, gcdr(a, b), asmGCDR(a, b), gcd(a, b), asmGCD(a, b));
	}

	return 0;
}
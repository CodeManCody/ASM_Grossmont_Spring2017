/**
* @class CSIS 165 - Assembly Language / Machine Architecture
* @author ICE10-Solution
* @instructor Bochsler
* @assignment Week 10
* @date 6 Apr 2017
*
* @brief
* Implement functions for ICE10 that combine pure Assembler Library and C/C++
*/

#include <stdint.h>
#include <stdio.h>

extern "C" {
	bool	isBitCountEven(int32_t);
}

static int32_t testData[] = {
	0x0,
	0x1,
	0x2,
	0x4,
	0x8,
	0x40000000,
	0x80000000,
	0x00000002,
	0xe,
	0xff770001,
	0xffeeeeff,
	0xdeadbeef,
	0xbaddf00d,
	0xd00fefac,
	0xfaceecaf,
	0xffffffff,
	0xaaaa5555
};
#define NUM_TEST_CASES	(sizeof (testData) / sizeof (*testData))


int main()
{
	printf("CSIS-165 ICE#10 Morgan\n\n");

	for (int i = 0; i < NUM_TEST_CASES; i++) {
		printf("isBitCountEven(0x%8x) yields: %s\n", testData[i], isBitCountEven(testData[i]) ? "true" : "false");
	}

	return 0;
}
/**
* @class CSIS 165 - Assembly Language / Machine Architecture
* @author ICE13-Solution
* @instructor Bochsler
* @assignment Week 13
* @date 28 Apr 2017
*
* @brief
* Implement functions for PA13 that combine pure Assembler Library and C/C++
*/
#include <stdio.h>
#include <stdint.h>
//#include <stdlib.h>
#include <string.h>
//#include <ctype.h>


extern "C" {
	void asmDoMath(const int8_t *a, const int16_t *b, int32_t *c, int max, int offset);
}

#define MAXDATA	5
static int8_t  aVec[MAXDATA] = { 2, 7, -4, 32, 127 };
static int16_t bVec[MAXDATA] = { 32767, 9360, 16380, 2049, 2048 };
static int32_t cVec[MAXDATA] = { 0 };

static void
cDoMath(const int8_t *a, const int16_t *b, int32_t *c, int max, int offset) {
	for (int i = 0; i < max; i++) {
		c[i] = a[i] * b[i] - offset;
	}
}

int main() {
	printf("CSIS-165 ICE#13 Morgan\n");

	cDoMath(aVec, bVec, cVec, MAXDATA, 7);

	printf("cDoMath() output:\n");
	for (int i = 0; i < MAXDATA; i++) {
		printf("a[%x] b[%x] => c[%x]\n", aVec[i], bVec[i], cVec[i]);
	}
	printf("\n");

	for (int i = 0; i < MAXDATA; i++) {
		cVec[i] = 0;
	}

	asmDoMath(aVec, bVec, cVec, MAXDATA, 7);

	printf("asmDoMath() output:\n");
	for (int i = 0; i < MAXDATA; i++) {
		printf("a[%x] b[%x] => c[%x]\n", aVec[i], bVec[i], cVec[i]);
	}
	printf("\n");

	return 0;
}
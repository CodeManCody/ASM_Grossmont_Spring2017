/**
* @class CSIS 165 - Assembly Language / Machine Architecture
* @author ICE7
* @instructor Bochsler
* @assignment Week 7
* @date 16 Mar 2017
*
* @brief
* Implement functions for ICE7 that combine pure Assembler Library and C/C++
*/

#include <stdint.h>
#include <stdio.h>

extern "C" {
	int32_t minOfThree(int32_t a, int32_t b, int32_t c);
}

int main()
{
	int32_t a, b, c;

	printf("CSIS-165 ICE#7 Morgan\n\n");

	printf("Enter 3 integers, separated by comma: ");
	scanf_s("%d, %d, %d", &a, &b, &c);
	printf("Values read [%d] [%d] [%d]\n", a, b, c);

	printf("Minimun is: ");
	minOfThree(a, b, c);
	printf("\n");

	return 0;
}
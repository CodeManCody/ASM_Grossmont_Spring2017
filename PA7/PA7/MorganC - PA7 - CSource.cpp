/**
* @class CSIS 165 - Assembly Language / Machine Architecture
* @author Cody Morgan
* @instructor Bochsler
* @assignment PA7
* @due_date 23 Mar 2017
*
* @brief
* Implement functions that combine pure Assembler Library and C/C++
*/

#include <stdint.h>
#include <stdio.h>

extern "C" {
	int32_t _LargestOfTwo(int32_t a, int32_t b);

	int32_t _LargestOfFour(int32_t w, int32_t x, int32_t y, int32_t z);

	int32_t _isSumLess(int32_t c, int32_t d, int32_t e);

	int32_t _complexCompare(int32_t h, int32_t i, int32_t j, int32_t k);
}

int main()
{
	printf("CSIS-165 PA7 Morgan\n\n");


	// Prob #1
	printf("The largest of the 4 args is: ");
	int32_t ret2 = _LargestOfFour(1, 2, 3, 4);
	printf("_LargestOfFour(1, 2, 3, 4) returns: ");
	ret2 = _LargestOfFour(1, 2, 3, 4);
	printf("Return value: %d\n\n", ret2);

	printf("The largest of the 4 args is: ");
	ret2 = _LargestOfFour(-91, 22, 300, -4);
	printf("_LargestOfFour(-91, 22, 300, -4) returns: ");
	ret2 = _LargestOfFour(-91, 22, 300, -4);
	printf("Return value: %d\n\n", ret2);

	printf("The largest of the 4 args is: ");
	ret2 = _LargestOfFour(-91, -22, -300, -4);
	printf("_LargestOfFour(-91, -22, -300, -4) returns: ");
	ret2 = _LargestOfFour(-91, -22, -300, -4);
	printf("Return value: %d\n\n", ret2);

	// Prob #2
	printf("The sum of x and y is ");
	int32_t ret = _isSumLess(1, 2, 4);
	printf(" z\n_isSumLess(1, 2, 4) returns: %d\n\n", ret);

	printf("The sum of x and y is ");
	ret = _isSumLess(4, 2, 1);
	printf(" z\n_isSumLess(4, 2, 1) returns: %d\n\n", ret);

	printf("The sum of x and y is ");
	ret = _isSumLess(1, 2, 3);
	printf(" z\n_isSumLess(1, 2, 3) returns: %d\n\n", ret);

	printf("The sum of x and y is ");
	ret = _isSumLess(-1, -2, -4);
	printf(" z\n_isSumLess(-1, -2, -4) returns: %d\n\n", ret);

	printf("The sum of x and y is ");
	ret = _isSumLess(-4, -2, -1);
	printf(" z\n_isSumLess(-4, -2, -1) returns: %d\n\n", ret);

	printf("The sum of x and y is ");
	ret = _isSumLess(-1, -2, -3);
	printf(" z\n_isSumLess(-1, -2, -3) returns: %d\n\n", ret);
	
	
	// Prob #3
	printf("Calling _complexCompare(40, 30, 20, 10): returns: ");
	_complexCompare(40, 30, 20, 10);
	printf("\n");

	printf("Calling _complexCompare(40, 30, 20, -4): returns: ");
	_complexCompare(40, 30, 20, -4);
	printf("\n");

	printf("Calling _complexCompare(40, 30, -3, 10): returns: ");
	_complexCompare(40, 30, -3, 10);
	printf("\n");

	printf("Calling _complexCompare(40, 30, -3, -4): returns: ");
	_complexCompare(40, 30, -3, -4);
	printf("\n");

	printf("Calling _complexCompare(40, -2, 20, 10): returns: ");
	_complexCompare(40, -2, 20, 10);
	printf("\n");

	printf("Calling _complexCompare(40, -2, 20, -4): returns: ");
	_complexCompare(40, -2, 20, -4);
	printf("\n");

	printf("Calling _complexCompare(40, -2, -3, 10): returns: ");
	_complexCompare(40, -2, -3, 10);
	printf("\n");

	printf("Calling _complexCompare(40, -2, -3, -4): returns: ");
	_complexCompare(40, -2, -3, -4);
	printf("\n");

	printf("Calling _complexCompare(-1, 30, 20, 10): returns: ");
	_complexCompare(-1, 30, 20, 10);
	printf("\n");

	printf("Calling _complexCompare(-1, 30, 20, -4): returns: ");
	_complexCompare(-1, 30, 20, -4);
	printf("\n");

	printf("Calling _complexCompare(-1, 30, -3, 10): returns: ");
	_complexCompare(-1, 30, -3, 10);
	printf("\n");

	printf("Calling _complexCompare(-1, 30, -3, -4): returns: ");
	_complexCompare(-1, 30, -3, -4);
	printf("\n");

	printf("Calling _complexCompare(-1, -2, 20, 10): returns: ");
	_complexCompare(-1, -2, 20, 10);
	printf("\n");

	printf("Calling _complexCompare(-1, -2, 20, -4): returns: ");
	_complexCompare(-1, -2, 20, -4);
	printf("\n");

	printf("Calling _complexCompare(-1, -2, -3, 10): returns: ");
	_complexCompare(-1, -2, -3, 10);
	printf("\n");

	printf("Calling _complexCompare(-1, -2, -3, -4): returns: ");
	_complexCompare(-1, -2, -3, -4);
	printf("\n");


	return 0;
}
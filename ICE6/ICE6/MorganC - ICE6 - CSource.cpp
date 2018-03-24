/**
* @class CSIS 165 - Assembly Language / Machine Architecture
* @author ICE6 Solution
* @instructor Bochsler
* @assignment ICE6
* @date 09 Mar 2017
*
* @brief
* Implement functions for ICE6 that combine pure Assembler Library and C/C++
*/

#include <stdint.h>
#include <stdio.h>

extern "C" {
	int32_t _myAsmFunc(int32_t a, int32_t b, int32_t c);
}

int main()
{
	printf("CSIS-165 ICE6 Morgan\n\n");

	printf("_myAsmFunc() returns: %d\n", _myAsmFunc(0, 10, 6));
	printf("_myAsmFunc() returns: %d\n", _myAsmFunc(0, 10, 7));
	printf("_myAsmFunc() returns: %d\n", _myAsmFunc(0, 8, 6));
	printf("_myAsmFunc() returns: %d\n", _myAsmFunc(0, 8, 7));
	printf("_myAsmFunc() returns: %d\n", _myAsmFunc(4, 10, 6));
	printf("_myAsmFunc() returns: %d\n", _myAsmFunc(4, 10, 7));
	printf("_myAsmFunc() returns: %d\n", _myAsmFunc(4, 8, 6));
	printf("_myAsmFunc() returns: %d\n", _myAsmFunc(4, 8, 7));

	/*if ((x > 3) && (y < 9) && (z >= 7)) 
				return (y + 2);
			else
				return (z);
		}
	*/



	printf("\n");

	return 0;
}
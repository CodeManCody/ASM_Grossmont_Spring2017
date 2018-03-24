// InClassWeek2.cpp : Defines the entry point for the console application.
// Cody Morgan

#include "stdafx.h"
#include <stdint.h>


static uint32_t
myFunc0(uint32_t x, uint32_t y) {
	__asm {
			MOV	eax, 0x76543210
			MOV	ebx, 0xfedcba98
			SUB	ebx, eax
			//mov eax, ebx
			; return value must be in eax
	}
	
}
// What is the return value ?  eax


static uint32_t
myFunc1(uint32_t x, uint32_t y) {
	__asm {
		MOV	eax, x
		ADD	eax, y

		; return value must be in eax
	}
	
}
// What is the return value ?  b




uint32_t	globalVal2 = 0xfedcba98;
uint32_t	globalVal1 = 0x76543210;

static uint32_t
myFunc2(uint32_t x, uint32_t y) {
	__asm {
		/* where the return value is equal to :
		!(globalVal2 - globalVal1) */

		MOV eax, globalVal2
		MOV ebx, globalVal1
		SUB eax, ebx
		NOT eax

		 }
}
// What is the return value ? 77777777







static uint8_t
myFunc3(uint8_t x, uint8_t y) {
	__asm {
		/* where the return value is equal to :
		(x & 0xf) || (y & 0xf0) */

		MOV al, x
		MOV ah, 0xf
		AND al, ah

		MOV bl, y
		MOV bh, 0xf0
		AND bl, bh

		OR al, bl

	}
}    // return value is 5



static uint16_t		// ax, bx, cx
myFunc4(uint16_t x, uint16_t y) {
	__asm {
		/* where the return value is equal to :
		(x + 32) + ((y + 64) - (x + y)) + 0x100 */

		MOV ax, x
		MOV bx, y
		MOV cx, y
		ADD cx, 64
		ADD bx, ax
		SUB cx, bx
		ADD ax, 32
		ADD ax, cx
		ADD ax, 256
		
		// return value is 0x160 or 352 in decimal

	}
}






int _tmain(int argc, _TCHAR* argv[])
{
	int y = myFunc0(2, 3);
	printf("myFunc0 return value is %x\n", y);

	int z = myFunc1(5, 6);
	printf("myFunc1 return value is %x\n", z);
	
	int a = myFunc2(4, 8);
	printf("myFunc2 return value is %x\n", a);

	int b = myFunc3(5, 6);
	printf("myFunc3 return value is %x\n", b);

	int c = myFunc4(4, 5);
	printf("myFunc4 return value is %x\n", c);



	return 0;
}


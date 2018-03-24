/**
* @class CSIS-165 - Assembly Language / Machine Architecture
* @author Cody Morgan
* @instructor Bochsler
* @assignment PA#2
* @duedate 2/16/17
*
* @brief
* Entry level machine language functions are created using basic opcodes
*/


#include "stdafx.h"
#include <stdint.h>
#include <iostream>


static uint32_t
Function1()
{
	__asm {

		MOV eax, 0x436F6479
		MOV ebx, 0x20202020
		XOR eax, ebx

	}	// return value is an inverse in the case of characters, ie, input == Cody, output == cODY
}


uint32_t	global1 = 66;
uint32_t	global2 = 28;

static uint32_t
Function2()
{
	__asm {

		MOV eax, global1
		MOV ebx, global2
		SUB eax, ebx
		ADD eax, 50
		MOV global1, eax

	}	// The return value was 88 (1988) in decimal, and I was born in January 1989
}


static uint32_t
Function3(uint32_t x, uint32_t y, uint32_t z)
{
	__asm {

		// (8 + x) + (0x100 + y) - (z + z) + 512

		MOV eax, x
		MOV ebx, y
		MOV ecx, z
		ADD eax, 8
		ADD ebx, 256
		ADD ecx, ecx
		ADD eax, ebx
		SUB eax, ecx
		ADD eax, 512

	}     
}		  
		  

static uint16_t
Function4(uint16_t x, uint16_t y)
{
	__asm {

		// (x + 100h) - (x - y) + 2(x - y)

		MOV ax, x
		MOV bx, y
		MOV cx, x
		MOV dx, x
		ADD cx, 256
		SUB ax, bx
		SUB cx, ax
		SUB dx, bx
		ADD dx, dx
		ADD dx, cx
		MOV ax, dx

	}			   
}


static uint8_t
Function5(uint8_t x, uint8_t y)
{
	__asm {

		// (x v y) ^ ~(x ^ y)

		MOV al, x
		MOV ah, y
		MOV bl, x
		MOV bh, y
		OR al, ah
		AND bl, bh
		NOT bl
		AND al, bl

	}
}




int _tmain(int argc, _TCHAR* argv[])
{
	printf("CSIS 165   PA#2   Morgan\n\n");

	int d = Function1();
	printf("Function1 return value is %x\n\n", d);

	int e = Function2();
	printf("Function2 return value is %x\n\n", e);

	int f = Function3(7, 5, 2);
	printf("Function3(7, 5, 2) return value is %x\n", f);

	int g = Function3(456, 123, 10);
	printf("Function3(456, 123, 10) return value is %x\n", g);

	int h = Function3(4096, 2048, 256);
	printf("Function3(4096, 2048, 256) return value is %x\n\n", h);

	int i = Function4(895, 2048);
	printf("Function4(895, 2048) return value is %x\n", i);

	int j = Function4(896, 2048);
	printf("Function4(896, 2048) return value is %x\n", j);

	int k = Function4(897, 2048);
	printf("Function4(897, 2048) return value is %x\n\n", k);

	int l = Function5(0x00, 0x00);
	printf("Function5(0x00, 0x00) return value is %x\n", l);

	int m = Function5(0x00, 0xff);
	printf("Function5(0x00, 0xff) return value is %x\n", m);

	int n = Function5(0xff, 0x00);
	printf("Function5(0xff, 0x00) return value is %x\n", n);

	int o = Function5(0xff, 0xff);
	printf("Function5(0xff, 0xff) return value is %x\n\n", o);


	return 0;
}


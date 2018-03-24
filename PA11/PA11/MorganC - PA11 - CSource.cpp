/**
* @class CSIS 165 - Assembly Language / Machine Architecture
* @author PA11-Solution
* @instructor Bochsler
* @assignment Week 11
* @date 20 Apr 2017
*
* @brief
* Implement functions for PA11 that combine pure Assembler Library and C/C++
*/
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

extern "C" {
	void sieveInit(int8_t *s, uint32_t l);
	void sieveRun(int8_t *s, uint32_t l);
	void sievePrint(int8_t *s, uint32_t l);
}

#define LIMIT 102			//size of array

int main() {
	int8_t *primeVec;

	printf("CSIS-165 PA#11 Morgan\n\n");

	printf("List of primes below %d as determined by the Sieve of Eratosthenes:\n",
		LIMIT);
	// allocate the vector for tracking primes
	primeVec = (int8_t *)malloc(sizeof(int8_t)* LIMIT);

	// init the vector
	sieveInit(primeVec, LIMIT);

	// run the sieve
	sieveRun(primeVec, LIMIT);

	// print the results
	sievePrint(primeVec, LIMIT);

	printf("\n");
	return 0;
}
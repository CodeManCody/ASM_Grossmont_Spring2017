/**
* @class CSIS 165 - Assembly Language / Machine Architecture
* @author PA14-Solution
* @instructor Bochsler
* @assignment Week 14
* @date 11 May 2017
*
* @brief
* Implement functions for PA14 that combine pure Assembler Library and C/C++
*/
#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define	MROWS		4
#define MCOLUMNS	4

static int8_t matrix_a[MROWS][MCOLUMNS] = { { 0, 1, 2, 3 }, { 10, 11, 12, 13 }, { 20, 21, 22, 23 }, { 30, 31, 32, 33 } };
static int8_t matrix_b[MROWS][MCOLUMNS] = { 0 };
static int8_t matrix_t[MROWS][MROWS] = { 0 };


extern "C" {
	/**
	* Copy smatrix to dmatrix, both of size row rcount, columns ccount.
	*
	*  @param [in] rcount	Row count of the source and destination matrices.
	*  @param [in] ccount	Column count of the source and destination matrices.
	*  @param [in] smatrix	Source matrix
	*  @param [out] dmatrix	Destination matrix
	*/
	void asmMatrixCopy(int rcount, int ccount, const int8_t smatrix[MROWS][MCOLUMNS], int8_t dmatrix[MROWS][MCOLUMNS]);

	/**
	* Compare matrices smatrix to dmatrix, both of size row rcount, columns ccount.
	*
	*  @param [in] rcount	Row count of both matrices.
	*  @param [in] ccount	Column count of both matrices.
	*  @param [in] smatrix	Source matrix
	*  @param [in] dmatrix	Destination matrix
	*
	*  @retval 0 - matrices were the same
	*  @retval !0 - matrices were different
	*/
	bool asmMatrixEqual(int rcount, int ccount, const int8_t smatrix[MROWS][MCOLUMNS], int8_t dmatrix[MROWS][MCOLUMNS]);

	/**
	* Transpose a matrix of size row rcount, columns ccount from smatrix to dmatrix.
	*
	*  @param [in] rcount	Row count of the source and destination matrices.
	*  @param [in] ccount	Column count of the source and destination matrices.
	*  @param [in] smatrix	Source matrix
	*  @param [out] dmatrix	Destination matrix
	*/
	bool asmMatrixTranspose(int rcount, int ccount, int8_t smatrix[MROWS][MCOLUMNS], int8_t dmatrix[MROWS][MCOLUMNS]);

	/**
	* Return the minimum element of a matrix of size row rcount, columns ccount.
	*
	*  @param [in] rcount	Row count of the source and destination matrices.
	*  @param [in] ccount	Column count of the source and destination matrices.
	*  @param [in] smatrix	Source matrix
	*
	*  @retval	- minimum element from the matrix
	*/
	uint8_t asmMatrixMin(int rcount, int ccount, const int8_t matrix[MROWS][MCOLUMNS]);

	/**
	* Return the maximum element of a matrix of size row rcount, columns ccount.
	*
	*  @param [in] rcount	Row count of the source and destination matrices.
	*  @param [in] ccount	Column count of the source and destination matrices.
	*  @param [in] smatrix	Source matrix
	*
	*  @retval	- maximum element from the matrix
	*/
	int8_t asmMatrixMax(int rcount, int ccount, const int8_t matrix[MROWS][MCOLUMNS]);

	/**
	* Add a constant offset to each element of a matrix of size row rcount, columns ccount.
	*
	*  @param [in] rcount	Row count of the source and destination matrices.
	*  @param [in] ccount	Column count of the source and destination matrices.
	*  @param [in] smatrix	Source matrix
	*  @param [in] offset	offset applied to each element
	*/
	void asmMatrixAdd(int rcount, int ccount, const int8_t matrix[MROWS][MCOLUMNS], uint8_t offset);
}

static void
cMatrixPrint(int rcount, int ccount, int8_t matrix[MROWS][MCOLUMNS])
{
	for (int r = 0; r < rcount; r++) {
		for (int c = 0; c < ccount; c++) {
			printf("%3d ", matrix[r][c]);
		}
		printf("\n");
	}
	printf("\n");
}


int main() {
	printf("CSIS-165 PA#14 Morgan\n\n");

	printf("Original matrix_a:\n");
	cMatrixPrint(MROWS, MCOLUMNS, matrix_a);

	printf("Orignal matrix_b:\n");
	cMatrixPrint(MROWS, MCOLUMNS, matrix_b);

	printf("Copy of matrix_a to matrix_b:\n");
	asmMatrixCopy(MROWS, MCOLUMNS, matrix_a, matrix_b);
	cMatrixPrint(MROWS, MCOLUMNS, matrix_b);

	printf("Compare of matrix_a and matrix_b yields: %c\n",
		asmMatrixEqual(MROWS, MCOLUMNS, matrix_a, matrix_b) ? 'F' : 'T');

	printf("Incremented matrix_b:\n");
	asmMatrixAdd(MROWS, MCOLUMNS, matrix_b, 50);
	cMatrixPrint(MROWS, MCOLUMNS, matrix_b);

	printf("Compare of matrix_a and matrix_b after increment yields: %c\n", asmMatrixEqual(MROWS, MCOLUMNS, matrix_a, matrix_b) ? 'F' : 'T');
	printf("\n");

	printf("Minimum element in matrix_b is %d\n", asmMatrixMin(MROWS, MCOLUMNS, matrix_b));
	printf("Maximum element in matrix_b is %d\n", asmMatrixMax(MROWS, MCOLUMNS, matrix_b));
	printf("\n");

	printf("Transpose of matrix_a to matrix_t yields:\n");
	asmMatrixTranspose(MROWS, MCOLUMNS, matrix_a, matrix_t);
	cMatrixPrint(MROWS, MCOLUMNS, matrix_t);

	return 0;
}
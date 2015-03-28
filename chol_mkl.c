/*-------------------------------- KERNEL : CHOLESKY DECOMPOSITION (USING MKL LIBRARY) --------------------------------*/
/*-------------------------------- TEAM : 14 --------------------------------------------------------------------------*/
/*-------------------------------- NAME : ATHIRA AJAYAKUMAR -----------------------------------------------------------*/
/*-------------------------------- UFID : 69398411 --------------------------------------------------------------------*/
/*-------------------------------- EMAIL ID : athira010192@ufl.edu ----------------------------------------------------*/ 


//header file declaration
#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<omp.h>
#include<time.h>
#include<mkl.h>
#include<sys/time.h>
#define  EPISILON (0.0001)
#define MAX_VALUE (1e6)


//function to calculate time
double timerval()	
{
	struct timeval st;
	gettimeofday(&st, NULL);
	return (st.tv_sec+st.tv_usec*1e-6);
}



//function to initialize the matrix as a positive definite matrix
void initialize(int n, double* A, double* P)	
{
	int i, j, k;
	
	//generating a random matrix
	for(i=0; i<n; i++) 
	{
		for(j=i; j<n; j++) 
		{
			double r = rand() % 100;
			A[i*n+j] = r;
			A[j*n+i] = A[i*n+j];
		}
	}

	
	//converting to positive definite matrix
	for(i=0; i<n; i++) 
	{
		for(j=0; j<n; j++) 
		{
			double sum = 0;
			for(k=0; k<n; k++) 
			{
				sum += A[i*n+k]*A[j*n+k];
			}
			P[i*n+j] = sum;
		}
	}
}



//main function
int main()
{
	double startTime = 0;
   	double endTime = 0;
   	double totalTime = 0;
	int i, l, n;
	int info;
	char uplo = 'L';
	
	for(i=1; i<12; i++) 
	{
		n = pow(2, i);
		double *A = (double *)(mkl_malloc((n*n) * sizeof(double),64));
		double *P = (double *)(mkl_malloc((n*n) * sizeof(double),64));	
		
		initialize(n, A, P); //function call to initialize matrix
		mkl_set_num_threads(240);
		
		startTime = timerval(); //start clock
		for(l=0;l<1000;l++) //Running the code 1000 times
		{
			info = LAPACKE_spotrf(LAPACK_ROW_MAJOR, uplo, n, P, n); //calling the mkl routine to perform cholesky decomposition
		} 
		endTime = timerval(); //stop clock
		
		freopen("cholesky.txt","a",stdout);
		printf("\n The parallel computation time for %d order matrix is : %f \n", n, ((endTime - startTime)/1000)); //Printing the average time		
		mkl_free(P);
		mkl_free(A);
	}
	return 0;
}


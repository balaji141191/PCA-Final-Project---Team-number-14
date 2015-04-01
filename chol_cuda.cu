/*-------------------------------- KERNEL : CHOLESKY DECOMPOSITION (USING cuSolver [CUDA] LIBRARY) --------------------*/
/*-------------------------------- TEAM : 14 --------------------------------------------------------------------------*/
/*-------------------------------- NAME : ATHIRA AJAYAKUMAR -----------------------------------------------------------*/
/*-------------------------------- UFID : 69398411 --------------------------------------------------------------------*/
/*-------------------------------- EMAIL ID : athira010192@ufl.edu ----------------------------------------------------*/ 


//header file declaration
#include<stdio.h>
#include<stdlib.h>
#include<assert.h>
#include<math.h>
#include<cusolverDn.h>
#include <cublas_v2.h>
#include<time.h>
#include<sys/time.h>
#define EPISILON (0.0001)
#define MAX_VALUE (1e6)


//function to compute the execution time
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
   	int i, j, n;
	cusolverStatus_t b_Status, s_status;
		
	for(i=1; i<13; i++) 
	{
		n = pow(2, i);
		
		//allocating memory for CPU variables
		double *A = (double *)malloc(n* n * sizeof(double));
		double *P = (double *)malloc(n* n * sizeof(double));
		initialize(n, A, P); //function call to initialize matrix
		
		//allocating memory for GPU variables
		double *B;
		cudaMalloc(&B, n* n * sizeof(double));
		cudaMemcpy(B, P, n * n * sizeof(double), cudaMemcpyHostToDevice);
		int *devInfo; 
		cudaMalloc(&devInfo, sizeof(int));
		int work_size = 0;

		//cuSolver initialization functions
		cusolverDnHandle_t handle;
    		cusolverDnCreate(&handle);
		
		b_status = cusolverDnDpotrf_bufferSize(handle, CUBLAS_FILL_MODE_LOWER, n, B, n, &work_size); //function for allocating buffer size
		
		double *work;
		cudaMalloc(&work, work_size * sizeof(double));
				
		startTime = timerval();
		for(j=0; j<1000; j++)	//Running the code 1000 times
		{
			
			s_status = cusolverDnDpotrf(handle, CUBLAS_FILL_MODE_LOWER, n, B, n, work, work_size, devInfo); //function for performing cholesky decomposition
						
		} 
		endTime = timerval();
		freopen("cholesky.txt","a",stdout);
		printf("\n The computation time for %d order matrix is : %f \n", n, ((endTime - startTime)/1000)); //Print the execution time 

		cusolverDnDestroy(handle);		
		cudaFree(B);
		free(P);
		free(A);		
	}
	return 0;
}

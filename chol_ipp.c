/*-------------------------------- KERNEL : CHOLESKY DECOMPOSITION (USING IPP LIBRARY) --------------------------------*/
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
#include<ippm.h>
#include<ippcore.h>
#include<ippvm.h>
#include<ipps.h>
#include<ippi.h>
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

	double *A = (double*)malloc(sizeof(double)*n*n);
	double *P = (double*)malloc(sizeof(double)*n*n);	
	
	for(i=1; i<12; i++) 
	{
		n = pow(2, i);
		initialize(n, A, P); //function call to initialize matrix

		//Source matrix parameters
		Ipp32f pSrc[n*n] = P; 
		int srcStride0 = n*sizeof(Ipp32f);
		int srcStride1 = n*sizeof(Ipp32f);
		int srcStride2 = sizeof(Ipp32f);

		//Decomposed matrix parameters    
		Ipp32f pDst[n*n] = {0}; 
		int dstStride0 = n*sizeof(Ipp32f);
		int dstStride1 = n*sizeof(Ipp32f);
		int dstStride2 = sizeof(Ipp32f);
		
		int count = 1;
		int widthHeight = n;
    
		ippSetNumThreads(240); //Function to set the total number of threads
		
		startTime = timerval(); //Start clock
		for(l=0;l<1000;l++) //Running the code 1000 times
		{
			//calling the ipp routine to perform cholesky decomposition
			IppStatus status = ippmCholeskyDecomp_ma_32f(const Ipp32f* pSrc, srcStride0, srcStride1, srcStride2, pDst, dstStride0, dstStride1, dstStride2, widthHeight, count); 
		} 
		endTime = timerval(); //Stop clock
		freopen("cholesky.txt","a",stdout);
		printf("\n The parallel computation time for %d order matrix of is : %f \n", n, ((endTime - startTime)/1000)); /*Printing the average time*/		
	}
	return 0;
}


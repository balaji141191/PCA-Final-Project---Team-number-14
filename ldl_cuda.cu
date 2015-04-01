/*********************** LDL Decomposition using CUDA ************************/
/*********************** Name: Balaji Rajasekaran ******************************/ 
/*********************** UFID:1918-2684 ****************************************/
/*********************** Email : balaji141191@ufl.edu **************************/
/*********************** Team-number : 14***************************************/


#include<stdio.h>
#include<stdlib.h>
#include<assert.h>
#include<math.h>
#include<time.h>

#include<cusolverDn.h>
#include <cublas_v2.h>

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

//function to generate a positive definite matrix
void init(int n, double* A, double* B) 
{
	int i, j, k;
	
	//creating a random matrix
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
			double s = 0;
			for(k=0; k<n; k++) 
			{
				s += A[i*n+k]*A[j*n+k];
			}
			B[i*n+j] = s;
		}
	}
}


//Main function
int main()
{
	double startTime = 0;
   	double endTime = 0;
   	int i, j, n;
	int info;
	    	
	cusolverStatus_t buffer_Status, solve_status;
	
	
	for(i=1; i<13; i++) 
	{
		n = pow(2, i);	//Run the routine for matrix of order 2 to 4096
	
		double *A = (double *)malloc(n* n * sizeof(double));
		double *B = (double *)malloc(n* n * sizeof(double));
		
		init(n, A, B); //initialize matrix function call
		
		double *M;
		cudaMalloc(&M, n* n * sizeof(double));		//Allocate memory for M in GPU

		cudaMemcpy(M, B, n * n * sizeof(double), cudaMemcpyHostToDevice);	//Copy contents of the initialised array from host to device memory
		
		int *devInfo; 
		cudaMalloc(&devInfo, sizeof(int));

		cusolverDnHandle_t handle;	//Initializing the CUDA solver	
    		cusolverDnCreate(&handle);
		
		int work_size = 0;
		buffer_status = cusolverDnDsytrf_bufferSize(handle, n, M, n, &work_size));	//CUDA sytrf initialization
		
		double *work;
		cudaMalloc(&work, work_size * sizeof(double));
		int I[n];
		
		startTime = timerval();
		for(j=0; j<1000; j++)	//Running the code 1000 times
		{
			
			solve_status = cusolverDnDsytrf(handle, CUBLAS_FILL_MODE_LOWER, n, M, n, I, work, work_size, devInfo);	//CUDA sytrf function execution
						
		} 
		endTime = timerval();
		freopen("ldl_CUDA_results.txt","a",stdout);
		printf("\n The computation time for %d order matrix is : %f \n", n, ((endTime - startTime)/1000)); //Print the execution time 

		cusolverDnDestroy(handle);
		
		cudaFree(M);
		free(B);
		free(A);		
	}
return 0;
}


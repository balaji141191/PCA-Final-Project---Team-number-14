/*********************** LDL Decomposition using OpenMP ************************/
/*********************** Name: Balaji Rajasekaran ******************************/ 
/*********************** UFID:1918-2684 ****************************************/
/*********************** Email : balaji141191@ufl.edu **************************/
/*********************** Team-number : 14***************************************/


#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<omp.h>
#include<time.h>
#include<mkl.h>
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
   	double totalTime = 0;
	int i, j, n;
	int info;
	char uplo = 'L';
	
	double *A = (double *)( mkl_malloc((n*n) * sizeof(double),64));
	double *B = (double *)( mkl_malloc((n*n) * sizeof(double),64));	
	
	for(i=1; i<12; i++) 
	{
		n = pow(2, i);
		init(n, A, B); //initialize matrix function call

		mkl_set_num_threads(240);		
		startTime = timerval();
		for(j=0; j<1000; j++)	//Running the code 1000 times
		{
			
			int M[n];
			info = LAPACKE_dsytrf(LAPACK_ROW_MAJOR, uplo, n, B, n, M); //mkl routine call to perform LDL decomposition
			if(info != 0)
			{
				printf("\n LDL decomposition failed \n");
			        mkl_free(B);
            			return 0;
			}	
		mkl_free(B);	
		} 
		endTime = timerval();
		freopen("ldl_results.txt","a",stdout);
		printf("\n The parallel computation time for %d order matrix is : %f \n", n, ((endTime - startTime)/1000)); //Print the execution time 		
		return 0;		
	}
}


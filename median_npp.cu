      /*********************** Median filter using NPP library for GPU **************/
/*********************** Ambareesh Chellappa UFID:1678 3293 Email : ambareesh.c@ufl.edu ***********/
/*create a file named result.txt in directory where the code is to be executed to store the results in the file */

#include <npp.h>
#include<stdio.h>
#include<math.h>
#include<stdlib.h>
double timerval()	//function to obtain time
{
	struct timeval st;
	gettimeofday(&st, NULL);
	return (st.tv_sec+st.tv_usec*1e-6);
}
int main()
{
int i, x; //variable for the for loop
for(i=2;i<10;i++)//for loop to the change the data size
{
	double start = 0; // variable to calculate the time
	double stop = 0;
	x=2^i;//changing the data size every loop
	int count = x*x; 
	float *src = (float *)malloc(count* sizeof(float)); // initializing memory in CPU for source
	float *dest = (float *)malloc(count* sizeof(float)); // initializing memory in CPU for destination
	int k;
	for(k=0;k<count;k++)//loop to randomly allocate value for the input image
	{
		src[k]=(rand()/255);
	}
	int gpu_x;
	float *gpu_src, *gpu_dest; //pointer for source img in GPU
	int *gpu_buffer; 	
	cudaMalloc(&gpu_src, count * sizeof(float)); //allocating memory for the input image to be processed in GPU
	cudaMalloc(&gpu_dest, count * sizeof(float)); //allocating memory for the processed image in GPU
	cudaMalloc(&gpu_buffer, count * sizeof(int)); //allocating memory for the processed image in GPU
	cudaMemcpy(gpu_src, src, count * sizeof(float), cudaMemcpyHostToDevice);//copying source image from CPU to GPU
	cudaMemcpy(gpu_x, x, sizeof(int), cudaMemcpyHostToDevice);//copying number of data to be processed from CPU to GPU
	NppiSize oMaskSize = {3, 3};
    NppiSize oSizeROI = {x,x};
    NppiPoint oAnchor = {0, 0};
	float nSrcStep = x * sizeof(float);//declaring the size of the input image
	float nDstStep = x * sizeof(float);//declaring the size of the output image
    int j;
	start=timerval();
	for (j=0;j<1000;j++)//running the code 1000 times to avoid delays
	{
		NppStatus nppiFilterMedian_32f_C4R (const Npp32f *gpu_src, Npp32s nSrcStep, Npp32f *gpu_dest, Npp32s nDstStep, NppiSize oSizeROI, NppiSize oMaskSize, NppiPoint oAnchor, Npp8u *gpu_buffer)
	}
	stop=timerval();
	freopen("result.txt","a",stdout);
	printf("\n the computation time for %d * %d input size is : %f",x,x,((stop-start)/1000)); /*displaying the computation time */
	cudaFree(gpu_src);
	cudaFree(gpu_dest);
	cudaFree(gpu_buffer);
	free(src);
	free(dest);
	}
}

	

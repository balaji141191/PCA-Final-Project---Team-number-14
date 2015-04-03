/*********************** Edge Detection using NPP Library functions ************************/
/***********************Filtering an Image using the vertical and horizonatal Prewitt kernels
/*********************** Name: Dinesh Kumar Sundararajan ******************************/ 
/*********************** UFID:61314525 ****************************************/
/*********************** Email : dsundar@ufl.edu **************************/
/******The file "result.txt" displays the parallel computation time 
**************************/

#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<npp.h>

double timerval()	//function to estimate time
{
	struct timeval st;
	gettimeofday(&st, NULL);
	return (st.tv_sec+st.tv_usec*1e-6);
}

int main()   //main function
{

    int i,j,k,n,count; //declaring variables

    for(i=3;i<20;i++)//loop for changing the input data size
    {
	double start = 0; //variables for time estimation
	double stop = 0;
	n = 2^i;//to change the data with every iteration of the loop
        count = n*n;
        
        float *src = (float *)malloc(count* sizeof(float)); // to initialize memory in CPU (source)
	float *dst = (float *)malloc(count* sizeof(float)); // to initialize memory in CPU (destination)

        for(k=0;k<count;k++)//loop to allocate random value for input image
	{
		src[k]=(rand()/255);
	}

        int gpu_n; //variable used to denote the number of data copied from CPU to GPU
  
        float *pSrc; //pSrc is the pointer to source image in GPU..
        float *pDst; //pDst is the pointer to destination image in GPU..

        cudaMalloc(&pSrc, count * sizeof(float)); //to allocate memory for the input image in GPU
	cudaMalloc(&pDst, count * sizeof(float)); //to allocate memory for the processed image in GPU
        
        cudaMemcpy(pSrc, src, count * sizeof(float), cudaMemcpyHostToDevice);//to copy the source image from CPU to GPU
	cudaMemcpy(gpu_n, n, sizeof(int), cudaMemcpyHostToDevice);//to copy the number of data to be processed from CPU to GPU 
        
        NppiSize oSizeROI = {n,n};

        float nSrcStep = n * sizeof(float);//to declare the size of the input image
	float nDstStep = n * sizeof(float);//to declare the size of the output image

        start=timerval();//start the timer

        for (j=0;j<1000;j++)//running the code 1000 times 
	{
            
                NppStatus nppiFilterPrewittHoriz_32f_C4R (const Npp32f *pSrc, Npp32s nSrcStep, Npp32f *pDst,Npp32s nDstStep, NppiSize oSizeROI); //Horizontal Prewitt Filter

                NppStatus nppiFilterPrewittVert_32f_C4R (const Npp32f *pSrc, Npp32s nSrcStep, Npp32f *pDst,Npp32s nDstStep, NppiSize oSizeROI); //Vertical Prewitt Filter
            
        }            

        stop=timerval();//stop the timer
	freopen("result.txt","a",stdout);//to store the computation time in result.txt
	printf("\n The computation time for %d * %d input size is : %f",n,n,((stop-start)/1000)); //to display the computation time
    
        cudaFree(pSrc);
	cudaFree(pDst);
	free(src);
	free(dst);


    }
}
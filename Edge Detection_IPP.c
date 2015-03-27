/*********************** Edge Detection using IPP Library functions ************************/
/***********************Filtering an Image using the vertical and horizonatal Prewitt kernels
/*********************** Name: Dinesh Kumar Sundararajan ******************************/ 
/*********************** UFID:61314525 ****************************************/
/*********************** Email : dsundar@ufl.edu **************************/
/******The file "result.txt" displays the parallel computation time 
**************************/
#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include "ippi.h"
#include "ippcore.h"
#include "ippvm.h"
#include "ipps.h"

double timerval()	//function to estimate time
{
	struct timeval st;
	gettimeofday(&st, NULL);
	return (st.tv_sec+st.tv_usec*1e-6);
}

int main()
{
int i,j,k,n; //declaring variables

    for(i=3;i<20;i++)//loop for changing the input data size
    {
	double start = 0; //variables for time estimation
	double stop = 0;
	n=2^i;//to change the data with every iteration of the loop

        IppiSize imgSize = {n,n};
	IppiSize maskSize = {3, 3};// Fixed mask size for edge detection 	

        Ipp8u pSrc [n*n]; //pSrc is the pointer to source image.. the size     is defined based on the input data size

        Ipp16s pDst[(n-1)*(n-1)];//pDst is the pointer to destination image.. the size is 1 row and 1 column lesser than the source image

        Ipp8u *pBuffer;//declaration for pointer to work buffer
      
        IppiSize roiSize = {n,n};

        IppiBorderType borderType = ippBorderRepl | ippBorderInMemTop | ippBorderInMemRight; //Different types of border available

        int srcStep = n * sizeof(Ipp8u);// srcStep is the distance in bytes, between the starting points of consecutive lines in the source image.

        int dstStep = (n-1) * sizeof(Ipp16s); dstStep is the distance in bytes, between the starting points of consecutive lines in the source image.

        int bufferSize; //variable to store the size of the buffer
      
        IppStatus status_horizontal; //the output image after using the horizontal prewitt filter is stored in status_horizontal.

        IppStatus status_vertical; //the output image after using the vertical prewitt filter is stored in status_vertical.

        ippiFilterPrewittHorizBorderGetBufferSize(roiSize, ippMskSize3x3, ipp8u, ipp16s, 1, &bufferSize); //function used to compute the size of the work buffer.

        pBuffer = ippsMalloc_8u(bufferSize);

        for(k=0;k<(n*n);k++)//loop to allocate random value for input image
	    {
		pSrc[k] = rand()%255;
	    }

        start=timerval();//start the timer

	for (j=0;j<1000;j++)//running the code 1000 times 
	   {

                status_horizontal = ippiFilterPrewittHorizBorder_8u16s_C1R    (pSrc + srcStep, srcStep, pDst, dstStep, roiSize,ippMskSize3x3,borderType, 0, pBuffer);//This function filters input image using the horizontal prewitt filter and stores the output in status_horizontal.

                status_vertical = ippiFilterPrewittVertBorder_8u16s_C1R(pSrc + srcStep, srcStep, pDst, dstStep, roiSize, ippMskSize3x3,borderType, 0, pBuffer);//This function filters the input image using the vertical prewitt filter and stores the output in status_vertical
      
           }

        stop=timerval();//stop the timer
	freopen("result.txt","a",stdout);//to store the computation time in result.txt
	printf("\n The computation time for %d * %d input size is : %f",n,n,((stop-start)/1000)); //to display the computation time
    
        ippsFree(pBuffer);
        ippsFree(status_horizontal);
        ippsFree(status_vertical);
   
   }
}
    

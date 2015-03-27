      /*********************** Median filter using IPP library  **************/
/*********************** Ambareesh Chellappa UFID:1678 3293 Email : ambareesh.c@ufl.edu ***********/
/*create a file named result.txt in directory where the code is to be executed to store the results in the file */
#include "ippi.h"
#include "ippcore.h"
#include "ippvm.h"
#include "ipps.h"
#include<stdio.h>
#include<math.h>
#include<stdlib.h>
double timerval()	//function to obtain time
{
	struct timeval st;
	gettimeofday(&st, NULL);
	return (st.tv_sec+st.tv_usec*1e-6);
}
int main ()
{
int i, x; //variable for the for loop
for(i=1;i<10;i++)//for loop to the change the data size
{
	double start = 0; // variable to calculate the time
	double stop = 0;
	x=2^i;//changing the data size every loop
	int count = x*x; 
	src = ippsMalloc_8u(count);//allocating memory for the input image
	dest = ippsMalloc_8u(count);//allocating memory for the resultant image
	//Ipp8u *pBuffer;//buffer pointer
	IppiSize roiSize = {x,x};	// declaring the region of interest in the input image
	IppiBorderType borderType = ippBorderRepl | ippBorderInMemTop | ippBorderInMemRight;//selecting the border type
	int srcStep = x * sizeof(Ipp8u);//declaring the size of the input image
	int dstStep = x * sizeof(Ipp8u);//declaring the size of the output image
	int bufferSize;
	IppStatus status;
	IppiPoint anchor = { 1,1 };
	IppiSize imgSize = {x,x};
	IppiSize maskSize = {3, 3};// max size to perform median filtering	
	int k;
	for(k=0;k<count;k++)//loop to randomly allocate value for the input image
	{
		//src[k]=(rand()/255);
		ippiSet_8u_C4R( (rand()/255), src, x, imgSize);
	}
	int j;
	start=timerval();
	for (j=0;j<1000;j++)//running the code 1000 times to avoid delays
	{
		//ippiFilterMedianBorderGetBufferSize(roiSize, maskSize, ipp8u, 1, &bufferSize);//finding the border size to perform median filtering
		//pBuffer = ippsMalloc_8u(bufferSize);
		status = ippiFilterMedian_8u_C4R(src + srcStep, srcStep, dest, dstStep, roiSize, maskSize, anchor); // median filter IPP function
		//ippsFree(pBuffer);
	}
	stop=timerval();
	freopen("result.txt","a",stdout);
	printf("\n the computation time for %d * %d input size is : %f",x,x,((stop-start)/1000)); /*displaying the computation time */
	ippsFree(src);
	ippsFree(dest);
}
}




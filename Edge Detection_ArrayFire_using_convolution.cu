/*********************** Edge Detection using ArrayFire Library functions ************************/
/***********************Using Convolution and gradient functions for Prewitt Operator*****************************************/
/*********************** Name: Dinesh Kumar Sundararajan ******************************/ 
/*********************** UFID:61314525 ****************************************/
/*********************** Email : dsundar@ufl.edu **************************/
/******The file "result.txt" displays the parallel computation time 
**************************/

#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<arrayfire.h>

double timerval()	//function to estimate time
{
	struct timeval st;
	gettimeofday(&st, NULL);
	return (st.tv_sec+st.tv_usec*1e-6);
}

int main()   //main function
{

    int i,j,k,n,count; //declaring variables
    //kernels for prewitt operator
    float h1[] = { 1, 1, 1};
    float h2[] = {-1, 0, 1};
 
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
        
         
        array dir, mag; //array fire library declaration to compute magnitude and direction
        const array in = array (n,n,src);//storing the input image in the form of array to be processed
       
        start=timerval();//start the timer

        for (j=0;j<1000;j++)//running the code 1000 times 
	{
            
         // Finding the gradients
         array Gy = convolve(3, h2, 3, h1, in)/6;
         array Gx = convolve(3, h1, 3, h2, in)/6;
 
         // Find magnitude and direction
         mag = hypot(Gx, Gy);
         dir = atan2(Gy, Gx);

        }            

        stop=timerval();//stop the timer
	freopen("result.txt","a",stdout);//to store the computation time in result.txt
	printf("\n The computation time for %d * %d input size is : %f",n,n,((stop-start)/1000)); //to display the computation time
    
        cudaFree(in);
	cudaFree(Gx);
        cudaFree(Gy);
        cudaFree(mag);
        cudaFree(dir);
	free(src);
	free(dst);

    }
}
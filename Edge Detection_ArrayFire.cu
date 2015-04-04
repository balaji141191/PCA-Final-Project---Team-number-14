/*********************** Edge Detection using ArrayFire Library functions ************************/
/***********************Using the Sobel filter*****************************************/
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
        
         
        af_array img, output; //array fire library declaration of array to process the data
        af_array img = array (n,n,src);//storing the input image in the form of array to be processed
     
       
        start=timerval();//start the timer

        for (j=0;j<1000;j++)//running the code 1000 times 
	{
             af_array output = AFAPI af_err af_sobel_operator( af_array *dx, af_array *dy, const af_array img, const unsigned ker_size = 3); //library function to perform edge detection       
            
        }            

        stop=timerval();//stop the timer
	freopen("result.txt","a",stdout);//to store the computation time in result.txt
	printf("\n The computation time for %d * %d input size is : %f",n,n,((stop-start)/1000)); //to display the computation time
    
        cudaFree(img);
	cudaFree(output);
	free(src);
	free(dst);

    }
}
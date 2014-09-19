#include "conv_lib.h"

// start_s is included but end_s is not
// launch this kernel with grid of kernel_stack * img_stack  (96 *5000)

// img[stack_num][channel][img_y][img_x]                                          5000 3 96 96
// kernel[kernel_stack_num][channel][kernel_y][kernex_x]                          96   3 7  7
// result[stack_num][kernel_stack_num][img_y-kernel_y + 1][img_x - kernel_x + 1]  5000 96 90 90
__global__ void valid_conv_kernel(float * img_base, float * filter_base, float * result_base,
	int img_x_dim, int img_y_dim, int channel,
	int filter_x_dim, int filter_y_dim){

	int img_stack      =  blockIdx.x;  // 5000

	int filter_stack   =  blockIdx.y; // 96
	int filter_stack_dim = blockDim.y;


	int result_x_dim = img_x_dim - filter_x_dim + 1;
	int result_y_dim = img_y_dim - filter_y_dim + 1;

	float * my_img_base = img_base + img_stack * img_x_dim * img_y_dim * channel;
	float * my_filter_base = filter_base + channel * filter_x_dim * filter_y_dim;
	float * my_result_base = result_base + img_stack * filter_stack_dim * result_x_dim * result_y_dim 
	                         + filter_stack * result_x_dim + result_y_dim;

#define result_v2(Y, X)     *(my_result_base + ( Y ) * result_x_dim + X)
#define filter_v3(C, Y, X)  *(my_filter_base + ( C )* filter_x_dim * filter_y_dim + ( Y ) * filter_x_dim + (X) )
#define img_v3(C, Y, X) 	*(my_img_base + ( C ) * img_y_dim * img_x_dim + ( Y )* img_x_dim + (X) )

	// int line_num = threadIdx.x;
	// int result_y_start =  line_num * line_step;
	// int result_y_end   =  line_num * (line_step + 1)
	for(int result_y = 0; result_y < result_y_dim; ++ result_y){
		for(int result_x = 0; result_x < result_x_dim; ++ result_x){
			float result = 0;
			for (int filter_c = 0; filter_c < channel; ++filter_c)
			{
				for (int filter_y = 0; filter_y < channel; ++filter_y){
					for (int filter_x = 0; filter_x < channel; ++filter_x){
						result += filter_v3(filter_c, filter_y, filter_x) * img_v3(filter_c, result_y_dim + filter_y, result_x_dim + filter_x);
					}
				}
			}
			result_v2(result_y, result_x) = result;
		}
	}


}



Status cuda_conv(Image img, Kernel ker, float *result){
	float  *img_base, *ker_base, *result_base;
	int img_size = img.image_x_dim * img.image_y_dim * img.image_channel * img.image_stack_num;
	int ker_size = ker.kernel_x_dim * ker.kernel_y_dim * ker.kernel_channel * ker.kernel_stack_num;
	int result_size = ker.kernel_stack_num * img.image_stack_num * (img.image_x_dim  - ker.kernel_x_dim + 1) * (img.image_y_dim - ker.kernel_y_dim + 1);

	cudaMalloc((void **) & img_base, img_size*sizeof(float));
	cudaMalloc((void **) & ker_base, ker_size*sizeof(float));
	cudaMalloc((void **) & result_base, result_size*sizeof(float));
	cudaMemcpy(img_base, img.image_base, img_size*sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(ker_base, ker.kernel_base, ker_size*sizeof(float), cudaMemcpyHostToDevice);

	int gridX = img.image_stack_num;
	int gridY = ker.kernel_stack_num;
	int threadX = 1;

	dim3 grid(gridX, gridY);
	dim3 block(threadX);
	valid_conv_kernel<<<grid, block, 0, 0>>>(img_base, ker_base, result_base, img.image_x_dim, img.image_y_dim, img.image_channel, 
		ker.kernel_x_dim, ker.kernel_y_dim);

	cudaMemcpy(result, result_base, result_size*sizeof(float), cudaMemcpyDeviceToHost);
	Status s;
	s.msg_len = 0;
	s.error = ALL_RIGHT;
	return s;

}


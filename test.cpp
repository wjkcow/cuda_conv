#include <stdio.h>
#include<cstring>
#include <iostream>
#include "conv_lib.h"
#include "cuda_conv.h"

using namespace std;

void fill(float *ptr, float number, int count){
	for(int i = 0; i < count; ++i){
		ptr[i] = number;
	}	
}
int main(){
	Image img; // 1 * 2 * 5 * 5
	Kernel ker; // 1 * 2 * 1 * 1

	img.image_x_dim = 5;
	img.image_y_dim = 5;
	img.image_channel = 2;
	img.image_stack_num = 1;


	ker.kernel_x_dim = 1;
	ker.kernel_y_dim = 1;
	ker.kernel_channel = 2;
	ker.kernel_stack_num = 1;

	img.image_base = new float[50];
	ker.kernel_base = new float[2];

	fill(img.image_base, 1, 50);
	fill(ker.kernel_base, 1, 2);


	float * result = new float[1000];
	fill(result, 0, 1000);
	cuda_conv(img,ker,result);
	int count = 0;

	for(int c = 0; c < img.image_channel; ++c){
		for (int x = 0; x < img.image_x_dim - ker.kernel_x_dim + 1; ++x)
		{
			for (int y = 0; y <  img.image_y_dim - ker.kernel_y_dim + 1; ++y)
			{
				cout << result[count ++] << " ";
			}
			cout << endl;
		}
	}

	cout << "##############" << endl;

	for(int i = 0; i < count; ++i){
		cout << result[i++];
	}
	cout << endl;
	return 0;

}

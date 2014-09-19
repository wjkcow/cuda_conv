#include <stdio.h>
#include <iostream>
#include "conv_lib.h"
#include "cuda_conv.h"

using namespace std;
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

	memset(img.image_base, 0, 50);
	memset(ker.kernel_base, 0, 2);


	float * result = new float[1000];
	memset(result, 0, 1000);
	cuda_conv(Image img, Kernel ker, float *result);
	int count = 0;

	for(int c = 0; c < img.image_channel; ++c){
		for (int x = 0; x < img.image_x_dim - ker.kernel_x_dim + 1; ++x)
		{
			for (int y = 0; y <  img.image_y_dim - ker.kernel_y_dim + 1; ++y)
			{
				cout << result[count ++];
			}
			cout << endl;
		}
	}

	cout << "##############" << endl;

	for(int i = 0; i < count; ++i){
		cout << result[i++];
	}
	return 0;

}
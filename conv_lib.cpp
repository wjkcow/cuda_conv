#include "conv_lib.h"

Status conv_alloc(Conv *conv){

}

Status conv_alloc(Conv *conv){


}

Status conv_validate(Image img, Kernel ker){
	Status error;
	error.msg_len = 0;
	error.error = INVAILD_INPUT;
	if(img.img_x_dim < ker.kernel_x_dim)
		return error;
	if(img.img_y_dim < ker.kernel_y_dim)
		return error;
	if(img.image_channel != ker.kernel_channel)
		return error;

	Status OK;
	error.msg_len = 0;
	error.error = ALL_RIGHT;
	return OK;
}
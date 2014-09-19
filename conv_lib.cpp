#include "conv_lib.h"

Status conv_alloc(Conv *conv){
	Status OK;
	OK.error_msg = 0;
	OK.msg_len = 0;
	OK.error = ALL_RIGHT;
	return OK;
}


Status conv_validate(Image img, Kernel ker){
	Status error;
	error.error_msg = 0;
	error.msg_len = 0;
	error.error = INVALID_INPUT;
	if(img.image_x_dim < ker.kernel_x_dim)
		return error;
	if(img.image_y_dim < ker.kernel_y_dim)
		return error;
	if(img.image_channel != ker.kernel_channel)
		return error;

	Status OK;
	OK.error_msg = 0;
	OK.msg_len = 0;
	OK.error = ALL_RIGHT;
	return OK;
}

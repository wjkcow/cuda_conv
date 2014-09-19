
#ifndef CONV_LIB_H
#define CONV_LIB_Hw

typedef char CONV_TYPE;
#define VALID 0

typedef char STATUS_CODE;
#define ALL_RIGHT    0
#define INVAID_INPUT 1

typedef struct Status_t{
	char * error_msg;
	int    msg_len;
	STATUS_CODE error;
} Status;

typedef struct image_t {
   float * image_base;
   int     image_x_dim;        // 96
   int     image_y_dim;        // 96
   int     image_channel;      // 3
   int     image_stack_num;    //5000
} Image;

typedef struct kernel_t {
	float * kernel_base;
	int     kernel_x_dim;      // 7 
	int     kernel_y_dim;      // 7
	int     kernel_channel;    // 3
	int     kernel_stack_num;  // 5000
} Kernel;
 
typedef struct conv_result_t{
	float * result_base;
	int     result_x_dim;     // 90
	int     result_y_dim;     // 90
	int     result_channel;   // 3
	int     result_stack_num; // 5000
} Conv_Result;

typedef struct conv_t {
	CONV_TYPE type;
	Image     image;
	Kernel    kernel;
	Conv_Result result;
	int       starts_stack;
	int       end_stack;
	
} Conv;

Status conv_alloc(Conv *conv);
Status conv_free(Conv *conv);
Status conv_validate(Image img, Kernel ker);


void seperate_image_stack();
void divid_image();
#endif /* CONV_LIB_H */


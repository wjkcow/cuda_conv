CUDA_INSTALL_PATH := /usr/local/cuda
 
CUDA  := $(CUDA_INSTALL_PATH)
 
INC     := -I$(CUDA)/include 
LIB     := -L$(CUDA)/lib   
 
# Mex script installed by Matlab
MEX = /usr/local/MATLAB/R2013b/bin/mex
 
# Flags for the CUDA nvcc compiler
NVCCFLAGS :=  -O=4 -arch=sm_11 --ptxas-options=-v -m 64
#THIS IS FOR DEBUG !!! -g -G
# IMPORTANT : don't forget the CUDA runtime (-lcudart) !
LIBS     := -lcudart -lcusparse -lcublas
 
# Regular C++ part
CXX = g++
CFLAGS = -Wall -c -O2 -fPIC $(INC)
LFLAGS = -Wall
AR = ar
 
all: dataloop mex
 
kernels:
     $(CUDA)/bin/nvcc cuda_conv.cu -c -o cuda_conv.cu.o $(INC) $(NVCCFLAGS)
 
main.o:        main_dataloop.cpp
     ${CXX} $(CFLAGS) $(INC) -o main.o main_dataloop.cpp
 
dataloop:     kernels main.o
     ${CXX} $(LFLAGS) -o demo_dataloop main.o dataloop.cu.o $(LIB) $(LIBS)
 
dataloop.a:     kernels
     ${AR} -r cuda_conv.a cuda_conv.cu.o
 
mex:     dataloop.a
     ${MEX} -L. -lcuda_conv -v mex_dataloop.cpp -L$(CUDA)/lib $(LIBS)
     install_name_tool -add_rpath /usr/local/cuda/lib mex_dataloop.mexmaci64
 
clean:
     rm *.o a.out *.a *.mexmaci* *~
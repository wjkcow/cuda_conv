# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin:/usr/local/cuda-5.5/bin
PATH=$PATH:/mnt/neocortex/library/intel/cce/10.1.026/bin/

LD_LIBRARY_PATH=''
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/neocortex/library/intel/cce/10.1.026/lib/
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/neocortex/library/intel/ipp/5.3.2.068/em64t/lib
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/wjkcow/lib
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-5.5/lib
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-5.5/lib64




export PATH
export LD_LIBRARY_PATH
export KMP_DUPLICATE_LIB_OK TRUE
export AF_PATH=/usr/local/arrayfire
export LM_LICENSE_FILE=/usr/local/arrayfire
export CUDA_PATH=/usr/local/cuda
export CUDA_INSTALL_PATH


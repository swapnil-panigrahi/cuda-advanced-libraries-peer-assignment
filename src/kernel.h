#ifndef KERNEL_H
#define KERNEL_H

#include <cuda_runtime.h>

// Wrapper function to call the CUDA kernel
void runSobelFilter(unsigned char* inputImage, unsigned char* outputImage, int width, int height);

#endif
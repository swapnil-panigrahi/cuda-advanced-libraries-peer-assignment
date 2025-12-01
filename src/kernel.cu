#include "kernel.h"
#include <cmath>

// Sobel Kernel matrices hardcoded for performance
// Gx = [[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]]
// Gy = [[-1, -2, -1], [0, 0, 0], [1, 2, 1]]

__global__ void sobelKernel(unsigned char* input, unsigned char* output, int width, int height) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    // Ensure we are inside the image boundaries and not on the very edge
    if (x > 0 && x < width - 1 && y > 0 && y < height - 1) {
        int Gx = 0;
        int Gy = 0;

        // Apply Sobel Operator
        // Loop over 3x3 window
        for(int i = -1; i <= 1; i++) {
            for(int j = -1; j <= 1; j++) {
                int pixelVal = input[(y + j) * width + (x + i)];

                // Sobel X weights
                int wx = 0;
                if (i == -1) wx = -1;
                if (i == 1) wx = 1;
                if (j == 0) wx *= 2; // Middle row weight is doubled

                // Sobel Y weights
                int wy = 0;
                if (j == -1) wy = -1;
                if (j == 1) wy = 1;
                if (i == 0) wy *= 2; // Middle column weight is doubled

                Gx += wx * pixelVal;
                Gy += wy * pixelVal;
            }
        }

        // Calculate magnitude
        int magnitude = (int)sqrtf((float)(Gx * Gx + Gy * Gy));
        
        // Clamp to 255
        if (magnitude > 255) magnitude = 255;
        if (magnitude < 0) magnitude = 0;

        output[y * width + x] = (unsigned char)magnitude;
    }
}

void runSobelFilter(unsigned char* h_input, unsigned char* h_output, int width, int height) {
    // Calculate total size in bytes (1 byte per pixel for grayscale)
    size_t imgSize = width * height * sizeof(unsigned char);

    unsigned char *d_input, *d_output;

    // Allocate Device Memory
    cudaMalloc((void**)&d_input, imgSize);
    cudaMalloc((void**)&d_output, imgSize);

    // Copy Input Data from Host to Device
    cudaMemcpy(d_input, h_input, imgSize, cudaMemcpyHostToDevice);

    // Define Grid and Block Dimensions
    dim3 blockSize(16, 16);
    dim3 gridSize((width + blockSize.x - 1) / blockSize.x, (height + blockSize.y - 1) / blockSize.y);

    // Launch Kernel
    sobelKernel<<<gridSize, blockSize>>>(d_input, d_output, width, height);

    // Synchronize to ensure kernel completion
    cudaDeviceSynchronize();

    // Copy Output Data from Device to Host
    cudaMemcpy(h_output, d_output, imgSize, cudaMemcpyDeviceToHost);

    // Free Memory
    cudaFree(d_input);
    cudaFree(d_output);
}
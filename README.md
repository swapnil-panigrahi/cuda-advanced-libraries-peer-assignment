# Real-Time Sobel Edge Detection with CUDA

## Project Overview
This Capstone Project implements a high-performance video processing pipeline using NVIDIA CUDA. It applies a **Sobel Edge Detection** filter to every frame of a video file. By parallelizing the convolution operation on the GPU, this application achieves real-time processing speeds.

## Requirements
* NVIDIA GPU
* CUDA Toolkit
* OpenCV (v4.0 or higher)
* GCC/G++

## Project Structure
* `src/main.cpp`: Handles video I/O using OpenCV and manages host memory.
* `src/kernel.cu`: Implements the parallel Sobel convolution kernel.
* `data/`: Folder for input videos.
* `output/`: Folder for processed videos.

## How to Run
We have provided an automated script for easy execution.

1. **Run the script:**
   ```bash
   chmod +x run.sh
   ./run.sh
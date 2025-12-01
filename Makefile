# Makefile for CUDA Sobel Edge Detection

# Compiler settings
NVCC      = nvcc
CXX       = g++

# Directories
SRC_DIR   = src
OBJ_DIR   = obj
BIN_DIR   = .

# CUDA paths (standard for WSL/Ubuntu CUDA install)
CUDA_INC  = /usr/local/cuda/include
CUDA_LIB  = /usr/local/cuda/lib64

# Compiler / linker flags
CXXFLAGS  = -std=c++11 -I$(SRC_DIR) -I$(CUDA_INC) `pkg-config --cflags opencv4`
NVCCFLAGS = -I$(SRC_DIR) -I$(CUDA_INC)
LDFLAGS   = `pkg-config --libs opencv4` -L$(CUDA_LIB) -lcudart

# Target executable
TARGET    = edge_detector

# File lists
CPP_SRCS  = $(SRC_DIR)/main.cpp
CU_SRCS   = $(SRC_DIR)/kernel.cu
CPP_OBJS  = $(OBJ_DIR)/main.o
CU_OBJS   = $(OBJ_DIR)/kernel.o

# Build rules
all: $(TARGET)

$(TARGET): $(CPP_OBJS) $(CU_OBJS)
	$(CXX) -o $@ $^ $(LDFLAGS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cu
	@mkdir -p $(OBJ_DIR)
	$(NVCC) $(NVCCFLAGS) -c $< -o $@

clean:
	rm -rf $(OBJ_DIR) $(TARGET) output/*.avi

.PHONY: all clean

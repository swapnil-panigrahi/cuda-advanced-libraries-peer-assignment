#!/bin/bash

INPUT_FILE="data/sample.mp4"
OUTPUT_FILE="output/edge_detected.avi"

mkdir -p data
mkdir -p output

if [ ! -f "$INPUT_FILE" ]; then
    echo "Downloading sample video..."
    wget -O "$INPUT_FILE" "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/360/Big_Buck_Bunny_360_10s_1MB.mp4"
fi

echo "Building Project..."
make clean
make

if [ ! -f "./edge_detector" ]; then
    echo "Build failed!"
    exit 1
fi

echo "Running Edge Detection..."
./edge_detector "$INPUT_FILE" "$OUTPUT_FILE"

echo "Done! Check '$OUTPUT_FILE' for the result."
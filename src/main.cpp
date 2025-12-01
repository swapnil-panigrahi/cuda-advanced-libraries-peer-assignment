#include <iostream>
#include <opencv2/opencv.hpp>
#include "kernel.h"

using namespace cv;
using namespace std;

int main(int argc, char** argv) {
    if (argc < 3) {
        cout << "Usage: ./edge_detector <input_video_path> <output_video_path>" << endl;
        return -1;
    }

    string inputPath = argv[1];
    string outputPath = argv[2];

    VideoCapture cap(inputPath);
    if (!cap.isOpened()) {
        cerr << "Error: Could not open video file." << endl;
        return -1;
    }

    // Get video properties
    int width = (int)cap.get(CAP_PROP_FRAME_WIDTH);
    int height = (int)cap.get(CAP_PROP_FRAME_HEIGHT);
    int fps = (int)cap.get(CAP_PROP_FPS);
    int totalFrames = (int)cap.get(CAP_PROP_FRAME_COUNT);

    cout << "Video Resolution: " << width << "x" << height << endl;
    cout << "Total Frames: " << totalFrames << endl;

    // Initialize VideoWriter for output
    VideoWriter writer(outputPath, VideoWriter::fourcc('M','J','P','G'), fps, Size(width, height), false);

    Mat frame, grayFrame;
    unsigned char* h_output = new unsigned char[width * height];

    int frameCount = 0;
    while (true) {
        cap >> frame;
        if (frame.empty()) break;

        // Convert to Grayscale (Sobel works on single channel)
        cvtColor(frame, grayFrame, COLOR_BGR2GRAY);

        // Run CUDA Kernel
        runSobelFilter(grayFrame.data, h_output, width, height);

        // Convert raw buffer back to OpenCV Mat
        Mat edgeFrame(height, width, CV_8UC1, h_output);

        // Write to file
        writer.write(edgeFrame);

        frameCount++;
        if (frameCount % 30 == 0) {
            cout << "Processed frame " << frameCount << "/" << totalFrames << "\r" << flush;
        }
    }

    cout << "\nProcessing Complete! Saved to " << outputPath << endl;

    // Cleanup
    delete[] h_output;
    cap.release();
    writer.release();

    return 0;
}
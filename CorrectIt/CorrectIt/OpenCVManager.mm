//
//  OpenCVManager.m
//  CorrectIt
//
//  Created by NamedPython on 2018/10/05.
//  Copyright © 2018年 HimawariClass. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

#import <Foundation/Foundation.h>
#import "OpenCVManager.h"

using namespace std;
using namespace cv;

@implementation OpenCVManager : NSObject
+(UIImage *)GrayScale:(UIImage *)image{
    // convert image to mat
    Mat mat;
    UIImageToMat(image, mat);
    
    // convert mat to gray scale
    Mat gray;
    cvtColor(mat, gray, CV_BGR2GRAY);
    
    // convert to image
    UIImage * grayImg = MatToUIImage(gray);
    return grayImg;
}

+(UIImage *)DetectProcess:(UIImage *)Uimage{
    //convert
    cv::Mat image, chExt, thed, contoursDrawed;
    UIImageToMat(Uimage, image);
    
    cv::cvtColor(image, chExt, CV_BGR2HSV);
    cv::extractChannel(chExt, chExt, 1);
    
    cv::threshold(chExt, thed, 50, 255, CV_THRESH_BINARY);
    
    //    return MatToUIImage(thed);
    
    cv::morphologyEx(thed, thed, CV_MOP_CLOSE, cv::getStructuringElement(CV_SHAPE_RECT, cv::Size(3, 1)));
    
    vector<vector<cv::Point>> contours, extracted;
    vector<Vec4i> hierarchy;
    
    cv::findContours(thed, contours, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_NONE);
    
    image.copyTo(contoursDrawed);
    for(const auto& contour: contours) {
        size_t index = &contour - &contours[0];
        if ((hierarchy[index].val[0] == -1 or hierarchy[index].val[2] == -1) and contourArea(contours[index]) > 8000) {
            printf("%d: %f\n", int(index), contourArea(contours[index]));
            extracted.emplace_back(contours[index]);
            drawContours(contoursDrawed, contours, int(index), cv::Scalar(255, 0, 255, 255), 10);
        } else {
            continue;
        }
    }
    
    cout << extracted.size() << endl;
    
    Mat colorImageCopy;
    image.copyTo(colorImageCopy);
    vector<cv::Scalar> colors;
    for (const auto& contour : extracted) {
        colors = {};
        const auto M = moments(contour);
        const auto centerOfCircle = cv::Point(int(M.m10/M.m00), int(M.m01/M.m00));
        int cnt = 0;
        for (const auto& approx : contour) {
            if (cnt == 20) break;
            //            cout << approx << endl;
            colors.emplace_back(image.at<Vec4b>(cv::Point(approx.x - 1, approx.y - 1)));
            cnt++;
        }
        const auto cav = cv::mean(colors);
        cout << cav << endl;
        circle(colorImageCopy, centerOfCircle, 100, cav, 20);
    }
    UIImage * result = MatToUIImage(colorImageCopy);
    return result;
}
@end

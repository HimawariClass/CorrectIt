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
#import <ctime>
#import <iostream>
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

+(string )ScalarToHex:(cv::Scalar )scalar {
    char result[12];
    sprintf(result, "#%02X%02X%02X", int(scalar[0]), int(scalar[1]), int(scalar[2]));
    
    cout << scalar << " -> " << string(result) << endl;
    return string(result);
}

+(NSMutableDictionary *)DetectProcess:(UIImage *)Uimage{
    printf("beginning detect process \n");
    clock_t begin = clock();

    //convert
    cv::Mat image, chExt, thed, contoursDrawed;
    UIImageToMat(Uimage, image);

    cvtColor(image, chExt, CV_BGR2HSV);
    extractChannel(chExt, chExt, 1);

    threshold(chExt, thed, 50, 255, CV_THRESH_BINARY);
    morphologyEx(thed, thed, CV_MOP_CLOSE, getStructuringElement(CV_SHAPE_RECT, cv::Size(3, 1)));

    vector<vector<cv::Point>> contours, extracted;
    vector<Vec4i> hierarchy;

    findContours(thed, contours, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_NONE);

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

    Mat colorImageCopy;
    image.copyTo(colorImageCopy);
    vector<cv::Scalar> samples;
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:extracted.size()];;
    NSString *fortest;
    for (const auto& contour : extracted) {
        samples = {};
        int cnt = 0;
        for (const auto& approx : contour) {
            if (cnt == 10) break;
            samples.emplace_back(image.at<Vec4b>(cv::Point(approx.x - 1, approx.y - 1)));
            cnt++;
        }
        const auto area = boundingRect(contour);
        const auto hex = [self ScalarToHex:cv::mean(samples)];
        UIImage * crop = MatToUIImage(image(area));
        char buffs[64];
        sprintf(buffs, "%d:%d:%s", area.x, area.y, hex.c_str());
        NSString *str = [NSString stringWithCString:buffs encoding:NSUTF8StringEncoding];
        [result setObject:crop forKey:str];
        fortest = [str copy];
    }

    const auto elapsed = double(clock() - begin) / CLOCKS_PER_SEC;
    printf("elapsed: %.03fsec\n", elapsed);
    
    cout << "result.count: " << result.count << endl;
    return result;
}
@end

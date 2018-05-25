//
//  OpenCVManager.m
//  CorrectIt
//
//  Created by Taillook on 2018/04/20.
//  Copyright © 2018年 HimawariClass. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

#import <Foundation/Foundation.h>
#import "OpenCVManager.h"

@implementation OpenCVManager : NSObject
+(UIImage *)GrayScale:(UIImage *)image{
    // convert image to mat
    cv::Mat mat;
    UIImageToMat(image, mat);
    
    // convert mat to gray scale
    cv::Mat gray;
    cv::cvtColor(mat, gray, CV_BGR2GRAY);
    
    // convert to image
    UIImage * grayImg = MatToUIImage(gray);
    
    return grayImg;
}
@end

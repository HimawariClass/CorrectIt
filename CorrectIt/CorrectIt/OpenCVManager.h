//
//  OpenCVManager.h
//  CorrectIt
//
//  Created by Taillook on 2018/04/20.
//  Copyright © 2018年 HimawariClass. All rights reserved.
//

#ifndef OpenCVManager_h
#define OpenCVManager_h
#import <UIKit/UIKit.h>
@interface OpenCVManager : NSObject
+(UIImage *)GrayScale:(UIImage *)image;
+(UIImage *)DetectProcess:(UIImage *)Uimage;
@end

#endif /* OpenCVManager_h */

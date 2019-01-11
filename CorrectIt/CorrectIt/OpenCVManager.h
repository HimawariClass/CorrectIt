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
#import <Foundation/Foundation.h>
@interface OpenCVManager : NSObject
+(UIImage *)GrayScale:(UIImage *)image;
+(NSMutableDictionary *)DetectProcess:(UIImage *)Uimage;
@end

#endif /* OpenCVManager_h */

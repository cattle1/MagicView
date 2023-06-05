//
//  MAGCameraManager.h
//  MagicView
//
//  Created by LL on 2021/10/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAGCameraManager : NSObject

/// 使用相机拍照并获取拍照的照片
+ (void)useCamera:(void (^) (UIImage *image))block;

@end

NS_ASSUME_NONNULL_END

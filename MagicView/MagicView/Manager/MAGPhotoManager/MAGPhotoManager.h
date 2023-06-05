//
//  MAGPhotoManager.h
//  MagicView
//
//  Created by LL on 2021/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAGPhotoManager : NSObject

/// 获取用户从相册选择的图片
+ (void)usePhotoLibrary:(void (^) (UIImage *image))block;

/// 保存多个媒体资料到相册
/// @discussion 可以保存的对象有PNG、JPG、GIF等各种图片常见格式
/// @param medias 数组内可以是本地/网络图片链接，也可以是UIImage对象
+ (void)saveMediasToPhotoLibrary:(NSArray *)medias;

@end

NS_ASSUME_NONNULL_END

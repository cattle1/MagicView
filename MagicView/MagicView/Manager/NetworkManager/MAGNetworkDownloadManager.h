//
//  MAGNetworkDownloadManager.h
//  MagicView
//
//  Created by LL on 2021/8/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAGNetworkDownloadManager : NSObject

/// 根据链接从互联网上下载指定文件
/// @discussion 如果已经下载那么会立即执行 completion，如果正在下载那么不会重复下载，
///             如果 savePath 不存在会自动创建路径上的文件夹
+ (void)downloadTaskWithURL:(NSURL *)URL
                   savePath:(NSString *)savePath
                   progress:(void (^ _Nullable)(NSProgress *downloadProgress))progress
          completionHandler:(void (^ _Nullable)(NSError * _Nullable error))completion;

/// 使用 YYWebImageManager 下载图片，completion 将在主线程中回调
+ (void)downloadImageWithURL:(NSURL *)imageURL completion:(void (^ _Nullable) (NSError * _Nullable error, UIImage * _Nullable image))completion;

+ (void)downloadImageWithURL:(NSURL *)imageURL;

@end

NS_ASSUME_NONNULL_END

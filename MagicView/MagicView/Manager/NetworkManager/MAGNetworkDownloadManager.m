//
//  MAGNetworkDownloadManager.m
//  MagicView
//
//  Created by LL on 2021/8/22.
//

#import "MAGNetworkDownloadManager.h"

#import <AFNetworking.h>

#import "MAGImport.h"

@implementation MAGNetworkDownloadManager

+ (void)downloadTaskWithURL:(NSURL *)URL
                   savePath:(NSString *)savePath
                   progress:(void (^)(NSProgress * _Nonnull))progress
          completionHandler:(void (^)(NSError * _Nullable))completion {
    if (URL == nil) return;
    if (mObjectIsEmpty(savePath)) return;
    if ([URL isKindOfClass:NSString.class]) URL = [NSURL URLWithString:(id)URL];
    
    // 创建文件路径上不存在的文件夹
    NSString *rootPath = savePath.stringByDeletingLastPathComponent;
    if (![mFileManager fileExistsAtPath:rootPath]) {
        [mFileManager createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 下载中的任务集合
    static NSMutableSet *downloadingSets;
    // 下载中的进度Block集合
    static NSMutableDictionary *progressDictionay;
    // 下载完成的Block集合
    static NSMutableDictionary * completionDictionay;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadingSets = [NSMutableSet set];
        progressDictionay = [NSMutableDictionary dictionary];
        completionDictionay = [NSMutableDictionary dictionary];
    });
    
    if ([downloadingSets containsObject:URL]) {
        NSMutableArray *progressArray = [progressDictionay[URL] mutableCopy];
        if (progress) {
            if (progressArray == nil) progressArray = [NSMutableArray array];
            [progressArray addObject:progress];
            [progressDictionay setObject:[progressArray copy] forKey:URL];
        }
        
        NSMutableArray *completionArray = [completionDictionay[URL] mutableCopy];
        if (completion) {
            if (completionArray == nil) completionArray = [NSMutableArray array];
            [completionArray addObject:completion];
            [completionDictionay setObject:[completionArray copy] forKey:URL];
        }
        return;
    }
    
    [downloadingSets addObject:URL];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *task = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:URL] progress:^(NSProgress * _Nonnull downloadProgress) {
        !progress ?: progress(downloadProgress);
        NSArray *progressArray = progressDictionay[URL];
        for (void (^t_block) (NSProgress *) in progressArray) {
            t_block(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return savePath.m_fileURL;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [downloadingSets removeObject:URL];
        
        !completion ?: completion(error);
        NSArray *completionArray = completionDictionay[URL];
        for (void (^t_block) (NSError *) in completionArray) {
            t_block(error);
        }
    }];
    
    [task resume];
}

+ (void)downloadImageWithURL:(NSURL *)imageURL {
    [self downloadImageWithURL:imageURL completion:nil];
}

+ (void)downloadImageWithURL:(NSURL *)imageURL completion:(void (^ _Nullable) (NSError * _Nullable error, UIImage * _Nullable image))completion {
    if (imageURL == nil) return;
    if ([imageURL isKindOfClass:NSString.class]) imageURL = [NSURL URLWithString:(id)imageURL];
    
    [[YYWebImageManager sharedManager] requestImageWithURL:imageURL options:kNilOptions progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        mDispatchAsyncOnMainQueue(!completion ?: completion(error, image))
    }];
}

@end

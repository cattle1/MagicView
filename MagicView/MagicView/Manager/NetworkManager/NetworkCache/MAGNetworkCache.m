//
//  LLNetworkCache.m
//  ZTCloud
//
//  Created by LL on 2021/4/24.
//

#import "MAGNetworkCache.h"

#import "MAGImport.h"

static NSString * const mIdentifier = @"magic_networkCache_oldAppVersion";

@interface MAGNetworkCache ()

@property (nonatomic, class, readonly) NSCache *memoryCache;

@end

@implementation MAGNetworkCache

+ (void)initialize {
    // 判断APP版本号是否发生变化，如果发生变化则清空之前的缓存
    NSString *oldAppVer = [mUserDefault objectForKey:mIdentifier];
    NSString *appVer = mAppVersion;
    if ([oldAppVer isEqualToString:appVer]) {
        [self clearCache];
        [mUserDefault setObject:appVer forKey:mIdentifier];
    }
}

+ (BOOL)saveJsonResponseToCacheFile:(id)jsonResponse URL:(NSString *)URL {
    return [self saveJsonResponseToCacheFile:jsonResponse URL:URL params:nil];
}

+ (BOOL)saveJsonResponseToCacheFile:(id)jsonResponse URL:(NSString *)URL params:(nullable NSDictionary *)params {
    if(jsonResponse == nil || mObjectIsEmpty(URL)) return NO;
    
    NSData * data= [jsonResponse modelToJSONData];
    NSString *cacheIdentifier = [self cacheIdentifierFromURL:URL params:params];
    [self memoryCacheFromData:jsonResponse forKey:cacheIdentifier];
    [self diskCacheFromData:data forKey:cacheIdentifier];
    return YES;
}

+ (void)saveAsyncJsonResponseToCacheFile:(id)jsonResponse URL:(NSString *)URL completed:(nullable MAGNetworkCacheCompletionBlock)block {
    [self saveAsyncJsonResponseToCacheFile:jsonResponse URL:URL params:nil completed:block];
}

+ (void)saveAsyncJsonResponseToCacheFile:(id)jsonResponse
                                     URL:(NSString *)URL
                                  params:(nullable NSDictionary *)params
                               completed:(nullable MAGNetworkCacheCompletionBlock)block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL result = [self saveJsonResponseToCacheFile:jsonResponse URL:URL params:params];
        !block ?: block(result);
    });
}

/// 内存缓存
+ (void)memoryCacheFromData:(id)data forKey:(NSString *)key {
    [MAGNetworkCache.memoryCache setObject:data forKey:key];
}

/// 磁盘缓存
+ (void)diskCacheFromData:(NSData *)data forKey:(NSString *)key {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [data m_writeToFile:[self fullPathForKey:key]];
    });
}

+ (nullable id)cacheJsonWithURL:(NSString *)URL {
    return [self cacheJsonWithURL:URL params:nil];
}

+ (nullable id)cacheJsonWithURL:(NSString *)URL params:(nullable NSDictionary *)params {
    if(mObjectIsEmpty(URL)) return nil;
    
    NSString *cacheIdentifier = [self cacheIdentifierFromURL:URL params:params];
    // 尝试从内存中获取缓存
    id json = [MAGNetworkCache.memoryCache objectForKey:cacheIdentifier];
    if (json) return json;
    
    // 尝试从磁盘中获取缓存
    NSString *fullPath = [self fullPathForKey:cacheIdentifier];
    NSDictionary *diskJson = [NSDictionary m_dictionaryWithContentsOfFile:fullPath];
    if (diskJson) {
        [MAGNetworkCache.memoryCache setObject:diskJson forKey:cacheIdentifier];
    }
    return diskJson;
}

+ (BOOL)checkCacheWithURL:(NSString *)URL {
    return [self checkCacheWithURL:URL params:nil];
}

+ (BOOL)checkCacheWithURL:(NSString *)URL params:(nullable NSDictionary *)params {
    if(mObjectIsEmpty(URL)) return NO;
    
    // 判断内存中是否存在
    NSString *cacheIdentifier = [self cacheIdentifierFromURL:URL params:params];
    id result = [MAGNetworkCache.memoryCache objectForKey:cacheIdentifier];
    if (result) return YES;
    
    // 判断磁盘中是否存在
    NSString *fullPth = [self fullPathForKey:cacheIdentifier];
    return [mFileManager fileExistsAtPath:fullPth];
}

+ (BOOL)clearCache {
    [MAGNetworkCache.memoryCache removeAllObjects];
    return [mFileManager removeItemAtPath:MAGFileManager.URLRequestCacheFolderPath error:nil];
}

+ (float)cacheSize {
    return MAGFileManager.URLRequestCacheFolderPath.m_fileSize / 1024.0;
}

+ (BOOL)clearCacheFromURL:(NSString *)URL {
    return [self clearCacheFromURL:URL params:nil];
}

+ (BOOL)clearCacheFromURL:(NSString *)URL params:(nullable NSDictionary *)params {
    NSString *cacheIdentifier = [self cacheIdentifierFromURL:URL params:params];
    [MAGNetworkCache.memoryCache removeObjectForKey:cacheIdentifier];
    NSString *fullPath = [self fullPathForKey:cacheIdentifier];
    return [mFileManager removeItemAtPath:fullPath error:nil];
}


#pragma mark - Private
+ (NSCache *)memoryCache {
    static NSCache *_memoryCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _memoryCache = [[NSCache alloc] init];
        _memoryCache.countLimit = 10;
    });
    return _memoryCache;
}

/// 根据URL和params生成一个唯一标识符
+ (NSString *)cacheIdentifierFromURL:(NSString *)URL params:(nullable NSDictionary *)params {
    NSString *paramsString = [params modelToJSONString] ?: @"";
    NSString *identifier = [URL stringByAppendingString:paramsString];
    return identifier.md5String;
}

/// 根据唯一标识符获取文件完整路径
+ (NSString *)fullPathForKey:(NSString *)key {
    NSString *identifier = [key stringByAppendingString:mAppVersion].md5String;
    return [MAGFileManager.URLRequestCacheFolderPath stringByAppendingPathComponent:identifier];
}

@end

//
//  LLNetworkCache.h
//  ZTCloud
//
//  Created by LL on 2021/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MAGNetworkCacheCompletionBlock)(BOOL result);

/// 管理网络接口缓存，当用户升级版本后会删除掉所有的接口缓存并重新缓存
@interface MAGNetworkCache : NSObject

/**
 *  写入/更新缓存(同步) [按APP版本号缓存,不同版本APP,同一接口缓存数据互不干扰]
 *
 *  @param jsonResponse 要写入的数据(JSON)
 *  @param URL    数据请求URL
 *
 *  @return 是否写入成功
 */
+ (BOOL)saveJsonResponseToCacheFile:(id)jsonResponse URL:(NSString *)URL;


/**
 *  写入/更新缓存(同步) [按APP版本号缓存,不同版本APP,同一接口缓存数据互不干扰]
 *
 *  @param jsonResponse 要写入的数据(JSON)
 *  @param URL    数据请求URL
 *  @param params 数据请求参数(没有传nil)
 *
 *  @return 是否写入成功
 */
+ (BOOL)saveJsonResponseToCacheFile:(id)jsonResponse URL:(NSString *)URL params:(nullable NSDictionary *)params;


/**
 *  写入/更新缓存(异步) [按APP版本号缓存,不同版本APP,同一接口缓存数据互不干扰]
 *
 *  @param jsonResponse    要写入的数据(JSON)
 *  @param URL             数据请求URL
 *  @param block  异步完成回调(主线程回调)
 */
+ (void)saveAsyncJsonResponseToCacheFile:(id)jsonResponse URL:(NSString *)URL completed:(nullable MAGNetworkCacheCompletionBlock)block;

/**
 *  写入/更新缓存(异步) [按APP版本号缓存,不同版本APP,同一接口缓存数据互不干扰]
 *
 *  @param jsonResponse    要写入的数据(JSON)
 *  @param URL             数据请求URL
 *  @param params          数据请求参数(没有传nil)
 *  @param block  异步完成回调(主线程回调)
 */
+ (void)saveAsyncJsonResponseToCacheFile:(id)jsonResponse URL:(NSString *)URL params:(nullable NSDictionary *)params completed:(nullable MAGNetworkCacheCompletionBlock)block;

/**
 *  获取缓存的对象(同步)
 *
 *  @param URL 数据请求URL
 *
 *  @return 缓存对象
 */
+ (nullable id)cacheJsonWithURL:(NSString *)URL;


/**
 *  获取缓存的对象(同步)
 *
 *  @param URL 数据请求URL
 *  @param params 数据请求参数
 *
 *  @return 缓存对象
 */
+ (nullable id)cacheJsonWithURL:(NSString *)URL params:(nullable NSDictionary *)params;


/// 检测是否已缓存该数据
/// @param URL 数据请求URL
/// @return YES已缓存, NO未缓存
+ (BOOL)checkCacheWithURL:(NSString *)URL;


/// 检测是否已缓存该数据
/// @param URL 数据请求URL
/// @param params  数据请求参数
/// @return YES已缓存, NO未缓存
+ (BOOL)checkCacheWithURL:(NSString *)URL params:(nullable NSDictionary *)params;

/// 清除所有缓存
+ (BOOL)clearCache;


/// 清除指定缓存
/// @param URL 数据请求URL
+ (BOOL)clearCacheFromURL:(NSString *)URL;


/// 清除指定缓存
/// @param URL 数据请求URL
/// @param params  数据请求参数
+ (BOOL)clearCacheFromURL:(NSString *)URL params:(nullable NSDictionary *)params;

/**
 *  获取缓存大小(单位:KB)
 *
 *  @return 缓存大小
 */
+ (float)cacheSize;

@end

NS_ASSUME_NONNULL_END

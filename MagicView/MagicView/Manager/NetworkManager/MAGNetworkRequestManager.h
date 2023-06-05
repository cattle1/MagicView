//
//  ZTNetworkRequestManager.h
//  ZTCloud
//
//  Created by LL on 2021/3/5.
//

#import <Foundation/Foundation.h>

#import "MAGServerLink.h"

@class MAGNetworkRequestModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ _Nullable m_requestSuccessBlock) (BOOL isSuccess, id _Nullable t_model, BOOL isCache, MAGNetworkRequestModel *requestModel);
typedef void(^ _Nullable m_requestFailedBlock) (NSURLSessionDataTask * _Nullable task, NSError *error);

@interface MAGNetworkRequestManager : NSObject

+ (nullable NSURLSessionDataTask *)POST:(NSString *)URL
                              parameters:(NSDictionary * _Nullable)parameters
                             modelClass:(Class _Nullable)modelClass
                                success:(m_requestSuccessBlock)success
                                failure:(m_requestFailedBlock)failure;


/// POST request
/// @param URL 请求地址，如果链接是http://或https://开头那么会直接按照URL地址进行请求
/// @param parameters 请求参数
/// @param modelClass 数据类型，设置为 nil 时 t_model 将是原始字典
/// @param needCache 是否需要缓存，默认值为 NO
/// @param autoRequest 是否需要自动恢复请求，默认值为 NO
///                   如果是 YES 那么当请求时没有网络会将请求保存起来等待网络恢复后再次请求，
///                   注意：如果成功或失败 block 块中有对 self 或其他外部对象的引用那么可能会导致对象延迟到网络恢复并请求完成才释放，
///                   建议只在单例或者那些不会释放的对象中使用该方法进行网络请求。
/// @param completionQueue 回调线程，如果为 nil 那么将在主线程中回调
/// @param success 成功回调
/// @param failure 失败回调
+ (nullable NSURLSessionDataTask *)POST:(NSString *)URL
                             parameters:(NSDictionary * _Nullable)parameters
                             modelClass:(Class _Nullable)modelClass
                              needCache:(BOOL)needCache
                            autoRequest:(BOOL)autoRequest
                        completionQueue:(dispatch_queue_t _Nullable)completionQueue
                                success:(m_requestSuccessBlock)success
                                failure:(m_requestFailedBlock)failure;

@end


@interface MAGNetworkRequestModel : NSObject

@property (nonatomic, strong, nullable) NSURLSessionDataTask *task;

@property (nonatomic, strong, nullable) NSDictionary *data;

@property (nonatomic, strong, nullable) NSString *msg;

@property (nonatomic, assign) NSInteger code;

@end

NS_ASSUME_NONNULL_END

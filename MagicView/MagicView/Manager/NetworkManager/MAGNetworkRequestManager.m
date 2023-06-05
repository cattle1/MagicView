//
//  ZTNetworkRequestManager.m
//  ZTCloud
//
//  Created by LL on 2021/4/24.
//

#import "MAGNetworkRequestManager.h"

#import "MAGNetworkCache.h"
#import "MAGNetworkReachabilityManager.h"
#import "MAGImport.h"

@implementation MAGNetworkRequestManager

+ (nullable NSURLSessionDataTask *)POST:(NSString *)URL
                             parameters:(NSDictionary * _Nullable)parameters
                             modelClass:(Class _Nullable)modelClass
                                success:(m_requestSuccessBlock)success
                                failure:(m_requestFailedBlock)failure {
    return [self POST:URL
           parameters:parameters
           modelClass:modelClass
            needCache:NO
          autoRequest:NO
      completionQueue:dispatch_get_main_queue()
              success:success
              failure:failure];
}

+ (nullable NSURLSessionDataTask *)POST:(NSString *)URL
                             parameters:(NSDictionary * _Nullable)parameters
                             modelClass:(Class _Nullable)modelClass
                              needCache:(BOOL)needCache
                            autoRequest:(BOOL)autoRequest
                        completionQueue:(dispatch_queue_t _Nullable)completionQueue
                                success:(m_requestSuccessBlock)success
                                failure:(m_requestFailedBlock)failure {
    if (![URL hasPrefix:@"http://"] &&
        ![URL hasPrefix:@"https://"]) {
        URL = [APIURL stringByAppendingString:URL.m_chineseURL];
    }
    
    if (completionQueue == nil) {
        completionQueue = dispatch_get_main_queue();
    }
    
    if (needCache) {
        // 读取缓存数据
        if ([MAGNetworkCache checkCacheWithURL:URL params:parameters]) {
            NSDictionary *cacheDictionary = [NSDictionary dictionaryWithDictionary:[MAGNetworkCache cacheJsonWithURL:URL params:parameters]];
            MAGNetworkRequestModel *requestModel = [[MAGNetworkRequestModel alloc] init];
            requestModel.data = cacheDictionary;
            dispatch_async(completionQueue, ^{
                !success ?: success(YES, modelClass ? [modelClass modelWithDictionary:cacheDictionary] : cacheDictionary, YES, requestModel);
            });
        }
    }
    
    if (!MAGNetworkReachabilityManager.isReachable) {
        if (autoRequest) {
            static NSMutableArray *requestArray;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                requestArray = [NSMutableArray array];
            });
            
            NSURLSessionDataTask * (^t_requestBlock)(void) = ^() {
                return [self POST:URL parameters:parameters modelClass:modelClass needCache:needCache autoRequest:autoRequest completionQueue:completionQueue success:success failure:failure];
            };
            [requestArray addObject:t_requestBlock];
            
            // 监听网络状态发生变化后遍历并重新请求
            [mNotificationCenter addObserverForName:MAGNetworkReachabilityStatusDidChangeNotification object:nil queue:NSOperationQueue.new usingBlock:^(NSNotification * _Nonnull note) {
                if (MAGNetworkReachabilityManager.isReachable) {
                    [requestArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSURLSessionDataTask *(^requestBlock)(void) = obj;
                        requestBlock();
                        [requestArray removeObject:obj];
                    }];
                }
            }];
        }
        return nil;
    }
    
    AFHTTPSessionManager *manager = [self defaultManager];
    manager.completionQueue = completionQueue;
    
    return [manager POST:URL
              parameters:[self appendParams:parameters]
                 headers:@{@"Content-Type":@"application/json", @"Accept":@"application/json"}
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [manager.session finishTasksAndInvalidate];
        
        NSDictionary *origin = nil;
        if (mInterfaceEncryptionSwitch) {
            origin = [NSDictionary m_dictionaryWithServerData:responseObject];
        } else {
            origin = [NSDictionary dictionaryWithDictionary:responseObject];
        }
        
        MAGNetworkRequestModel *requestModel = [[MAGNetworkRequestModel alloc] init];
        requestModel.task = task;
        NSDictionary *t_data = origin[@"data"];
        if ([t_data isKindOfClass:NSDictionary.class]) {
            requestModel.data = t_data;
        }
        requestModel.data = t_data;
        requestModel.msg = [NSString stringWithFormat:@"%@", origin[@"msg"]];
        NSString *codeString = [NSString stringWithFormat:@"%@", origin[@"code"]];
        requestModel.code = [codeString integerValue];
        
        id t_model = modelClass == nil ? origin : [modelClass modelWithDictionary:requestModel.data];
        !success ?: success((requestModel.code == 0), t_model, NO, requestModel);
        
        if (requestModel.code == 0 &&
            needCache) {
            [MAGNetworkCache saveAsyncJsonResponseToCacheFile:requestModel.data URL:URL params:parameters completed:nil];
        }
        
        if (requestModel.code != 0) {
            [MAGClickAgent event:@"接口请求错误" attributes:@{@"url" : URL, @"code" : @(requestModel.code), @"msg" : requestModel.msg ?: @"NULL"}];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [manager.session finishTasksAndInvalidate];
        
        !failure ?: failure(task, error);
        [MAGClickAgent event:@"网络请求错误" attributes:@{@"url" : URL, @"code" : @(error.code), @"msg" : error.localizedDescription ?: @"NULL"}];
    }];
}


#pragma mark - Private
+ (AFHTTPSessionManager *)defaultManager {
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = securityPolicy;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    if (mInterfaceEncryptionSwitch) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript",@"text/plain",@"application/javascript",@"video/mpeg",@"video/mp4", nil];
        manager.responseSerializer = responseSerializer;
    } else {
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript",@"text/plain",@"application/javascript",@"video/mpeg",@"video/mp4", nil];
        manager.responseSerializer = responseSerializer;
    }
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setTimeoutInterval:30.0];

    return manager;
}

+ (NSDictionary *)appendParams:(NSDictionary * _Nullable)origin {
    NSString *md5Str = [[app_key md5String] substringWithRange:NSMakeRange(0, 6)];

    static NSDictionary *basicParams;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary *_basicParams = [NSMutableDictionary dictionary];
        [_basicParams setObject:App_ID forKey:[NSString stringWithFormat:@"%@_%@",md5Str,@"appId"]];
        [_basicParams setObject:mBundleIdenfier forKey:[NSString stringWithFormat:@"%@_%@",md5Str,@"packageName"]];
        [_basicParams setObject:[NSString m_UUIDString] forKey:[NSString stringWithFormat:@"%@_%@",md5Str,@"udid"]];
        basicParams = [_basicParams copy];
    });
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:basicParams];
    [params setObject:MAGUserInfoManager.userInfo.user_token ?: @"" forKey:[NSString stringWithFormat:@"%@_%@",md5Str,@"token"]];
    [params setObject:@"en" forKey:[NSString stringWithFormat:@"%@_%@",md5Str,@"language"]];
    [params setObject:LLDarkManager.isDarkMode ? @"1" : @"0" forKey:[NSString stringWithFormat:@"%@_%@",md5Str,@"is_dark"]];
    [params setObject:@"1" forKey:@"debug"];

    for (NSString *key in origin.allKeys) {
        if ([key isEqualToString:@"udid"]) {
            [params removeObjectForKey:[NSString stringWithFormat:@"%@_%@",md5Str,@"udid"]];
        }
        if ([key isEqualToString:@"language"]) { // 特殊接口,参数不处理
            [params setObject:origin[key] forKey:key];
        } else {
            [params setObject:origin[key] forKey:[NSString stringWithFormat:@"%@_%@",md5Str,key]];
        }
    }
    
    [params setObject:params.m_serverSignString forKey:[NSString stringWithFormat:@"%@_%@",md5Str,@"sign"]];

    return [params copy];
}

@end


@implementation MAGNetworkRequestModel

@end

//
//  MAGClickAgent.m
//  MagicView
//
//  Created by LL on 2021/9/20.
//

#import "MAGClickAgent.h"

#import "MAGImport.h"
#import "MAGNetworkRequestManager.h"
#import <MediaPlayer/MPMusicPlayerController.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <ifaddrs.h>

static NSMutableArray *_appearVCArray;
static NSMutableDictionary<NSString *, NSDictionary *> *_eventList;
static dispatch_queue_t _queue;

@implementation MAGClickAgent

// 监听系统状态
+ (void)initialize {
    _appearVCArray = [NSMutableArray array];
    _queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    
    [mNotificationCenter addObserverForName:SystemThemeDidChangeNotification object:nil queue:NSOperationQueue.new usingBlock:^(NSNotification * _Nonnull note) {
        if (@available(iOS 13.0, *)) {
            [MAGClickAgent event:@"用户切换系统深色模式" attributes:@{@"is_dark" : LLDarkManager.isSystemDarkMode ? @"YES" : @"NO"}];
        }
    }];
    
    [mNotificationCenter addObserverForName:UIApplicationSignificantTimeChangeNotification object:nil queue:NSOperationQueue.new usingBlock:^(NSNotification * _Nonnull note) {
        [MAGClickAgent event:@"系统时间发生重大变化"];
    }];
    
    [mNotificationCenter addObserverForName:UIApplicationUserDidTakeScreenshotNotification object:nil queue:NSOperationQueue.new usingBlock:^(NSNotification * _Nonnull note) {
        [MAGClickAgent event:@"用户进行了截屏操作"];
    }];
    
    [mNotificationCenter addObserverForName:MPMusicPlayerControllerVolumeDidChangeNotification object:nil queue:NSOperationQueue.new usingBlock:^(NSNotification * _Nonnull note) {
        [MAGClickAgent event:@"用户调节了系统音量"];
    }];
    
    [mNotificationCenter addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:NSOperationQueue.new usingBlock:^(NSNotification * _Nonnull note) {
        [MAGClickAgent event:@"APP已获得焦点"];
    }];
    
    [mNotificationCenter addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:NSOperationQueue.new usingBlock:^(NSNotification * _Nonnull note) {
        [mUserDefault prompt_setObject:_eventList forKey:mClickEventDataIdentifier];
        [MAGClickAgent event:@"APP已失去焦点"];
    }];

    [mNotificationCenter addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:NSOperationQueue.new usingBlock:^(NSNotification * _Nonnull note) {
        [MAGClickAgent event:@"APP已进入后台"];
    }];
    
    [mNotificationCenter addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [MAGClickAgent event:@"系统内存不足"];
    }];

    [mNotificationCenter addObserverForName:UIApplicationWillTerminateNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [MAGClickAgent event:@"APP即将终止运行"];
    }];
    
    // 检测本地是否有未上传的埋点
    _eventList = [[mUserDefault objectForKey:mClickEventDataIdentifier] mutableCopy];
    if (_eventList == nil) _eventList = [NSMutableDictionary dictionary];
    
    [_eventList enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSDictionary * _Nonnull params, BOOL * _Nonnull stop) {
        [self mp_uploadClickEvent:params success:^{
            [_eventList removeObjectForKey:key];
        } isLoacl:YES];
    }];
}

+ (void)event:(NSString *)eventName {
    [self event:eventName attributes:nil];
}

+ (void)event:(NSString *)eventName attributes:(nullable NSDictionary *)attributes {
#if DEBUG
    return;
#endif
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
    if (mObjectIsEmpty(eventName)) return;
    
    dispatch_async(_queue, ^{
        NSMutableDictionary *params = [@{
            @"event_name" : eventName
        } mutableCopy];
        
        UIDevice *device = [UIDevice currentDevice];
        device.batteryMonitoringEnabled = YES;
        
        static NSDictionary *basicParams;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            CTCarrier *carrier = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_15_0
            if (@available(iOS 12.0, *)) {
                carrier = [info serviceSubscriberCellularProviders].allValues.firstObject;
            } else {
                carrier = [info subscriberCellularProvider];
            }
#else
            carrier = [info subscriberCellularProvider];
#endif
            
            basicParams = @{
                @"phone_name" : device.name,
                @"system_language" : [NSLocale preferredLanguages].firstObject ?: @"NULL",
                @"locale_country" : [NSLocale.currentLocale objectForKey:NSLocaleCountryCode] ?: @"NULL",
                @"carrier_name" : [carrier carrierName] ?: @"NULL",
                @"iso_country_code" : [carrier isoCountryCode] ?: @"NULL",
                @"open_vpn" : [self mp_isVPNOn] ? @"YES" : @"NO",
            };
        });
        
        [params addEntriesFromDictionary:basicParams];
        [params addEntriesFromDictionary:attributes];
        [params addEntriesFromDictionary:[self mp_isProxyOn]];
        
        switch (device.batteryState) {
            case UIDeviceBatteryStateUnplugged: {
                [params setObject:@"非充电状态" forKey:@"battery_state"];
            }
                break;
            case UIDeviceBatteryStateCharging: {
                [params setObject:@"充电状态" forKey:@"battery_state"];
            }
                break;
            case UIDeviceBatteryStateFull: {
                [params setObject:@"连接充电器并且充满状态" forKey:@"battery_state"];
            }
                break;
            default: break;
        }
        
        
        switch ([YYReachability reachability].status) {
            case YYReachabilityStatusNone: {
                [params setObject:@"无网络" forKey:@"network_status"];
            }
                break;
            case YYReachabilityStatusWWAN: {
                [params setObject:@"数据流量" forKey:@"network_status"];
            }
                break;
            case YYReachabilityStatusWiFi: {
                [params setObject:@"WiFi" forKey:@"network_status"];
            }
                break;
        }
        
#if TARGET_IPHONE_SIMULATOR
        [params setObject:@"YES" forKey:@"is_emulator"];
#else
        [params setObject:@"NO" forKey:@"is_emulator"];
#endif
        
        [params setObject:mNSStringFromFloat(device.batteryLevel * 100) forKey:@"battery_level"];
        [params setObject:MAGClickAgent.topViewControllerName ?: @"NULL" forKey:@"vc_name"];
        
        NSString *timestamp = mTimestampMillisecondString;
        [_eventList setObject:params forKey:timestamp];
        [self mp_uploadClickEvent:params success:^{
            [_eventList removeObjectForKey:timestamp];
        } isLoacl:NO];
    });
#pragma clang diagnostic pop
}

+ (void)appendDidAppearViewControllerName:(NSString *)aName {
    [_appearVCArray insertObject:aName atIndex:0];
}

+ (NSArray<NSString *> *)didAppearViewControllerArray {
    return [_appearVCArray copy];
}

+ (nullable NSString *)topViewControllerName {
    return _appearVCArray.firstObject;
}


#pragma mark - Private
+ (void)mp_uploadClickEvent:(NSDictionary *)params success:(void(^)(void))success isLoacl:(BOOL)isLocal {
    NSString *upReviewURL = @"http://open-inner.beiwo-xiaoshuo.com/service/up-review";
    NSString *url = params[@"url"];
    /// 由于接口报错也会上报，这里判断一下避免循环调用
    if ([url isEqualToString:upReviewURL]) return;
    
    NSMutableDictionary *t_params = [params mutableCopy];
    [t_params setObject:isLocal ? @"YES" : @"NO" forKey:@"is_local"];
    
    [MAGNetworkRequestManager POST:upReviewURL
                        parameters:t_params
                        modelClass:nil
                         needCache:NO
                       autoRequest:NO
                   completionQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
                           success:^(BOOL isSuccess, id  _Nullable t_model, BOOL isCache, MAGNetworkRequestModel * _Nonnull requestModel) {
        if (isSuccess) !success ?: success();
    } failure:nil];
}

/// 是否开启了VPN
+ (BOOL)mp_isVPNOn {
   BOOL flag = NO;
   NSString *version = [UIDevice currentDevice].systemVersion;
   // need two ways to judge this.
   if (version.doubleValue >= 9.0) {
       NSDictionary *dict = CFBridgingRelease(CFNetworkCopySystemProxySettings());
       NSArray *keys = [dict[@"__SCOPED__"] allKeys];
       for (NSString *key in keys) {
           if ([key rangeOfString:@"tap"].location != NSNotFound ||
               [key rangeOfString:@"tun"].location != NSNotFound ||
               [key rangeOfString:@"ipsec"].location != NSNotFound ||
               [key rangeOfString:@"ppp"].location != NSNotFound){
               flag = YES;
               break;
           }
       }
   } else {
       struct ifaddrs *interfaces = NULL;
       struct ifaddrs *temp_addr = NULL;
       int success = 0;
       
       // retrieve the current interfaces - returns 0 on success
       success = getifaddrs(&interfaces);
       if (success == 0) {
           // Loop through linked list of interfaces
           temp_addr = interfaces;
           while (temp_addr != NULL) {
               NSString *string = [NSString stringWithFormat:@"%s" , temp_addr->ifa_name];
               if ([string rangeOfString:@"tap"].location != NSNotFound ||
                   [string rangeOfString:@"tun"].location != NSNotFound ||
                   [string rangeOfString:@"ipsec"].location != NSNotFound ||
                   [string rangeOfString:@"ppp"].location != NSNotFound) {
                   flag = YES;
                   break;
               }
               temp_addr = temp_addr->ifa_next;
           }
       }
       
       freeifaddrs(interfaces);
   }

   return flag;
}

/// 如果APP开启了代理，则返回代理相关信息
+ (NSDictionary *)mp_isProxyOn {
    NSMutableDictionary *t_dict = [NSMutableDictionary dictionary];
    
    CFDictionaryRef proxySettings = CFNetworkCopySystemProxySettings();
    CFArrayRef proxies = CFNetworkCopyProxiesForURL((__bridge CFURLRef)([NSURL URLWithString:@"https://www.baidu.com"]), proxySettings);
    CFRelease(proxySettings);
    NSDictionary *settings = (__bridge NSDictionary *)CFArrayGetValueAtIndex(proxies, 0);
    CFRelease(proxies);
    if (![settings isKindOfClass:NSDictionary.class]) return @{};
    
    NSString *key = [settings objectForKey:(NSString *)kCFProxyTypeKey];

    if([key isEqualToString:@"kCFProxyTypeNone"]) {
        [t_dict setObject:@"NO" forKey:@"open_proxy"];
    } else {
        [t_dict setObject:@"YES" forKey:@"open_proxy"];
        NSString *proxyIP = [settings objectForKey:(NSString *)kCFProxyHostNameKey] ?: @"NULL";
        [t_dict setObject:proxyIP forKey:@"proxy_ip"];
        NSString *proxyPort = [settings objectForKey:(NSString *)kCFProxyPortNumberKey] ?: @"NULL";
        [t_dict setObject:proxyPort forKey:@"proxy_port"];
    }
    
    return [t_dict copy];
}

@end

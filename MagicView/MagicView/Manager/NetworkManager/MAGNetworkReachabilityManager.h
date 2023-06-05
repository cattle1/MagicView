//
//  ZTNetworkReachabilityManager.h
//  ZTCloud
//
//  Created by LL on 2021/4/24.
//

#import <Foundation/Foundation.h>

#import <AFNetworking.h>
#import <CoreTelephony/CTCellularData.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAGNetworkReachabilityManager : NSObject

/// 获取当前网络的可达性状态
@property (nonatomic, readonly, class) BOOL isReachable;

/// 获取当前网络的状态类型
@property (nonatomic, readonly, class) AFNetworkReachabilityStatus networkReachabilityStatus;

/// 获取APP当前的蜂窝数据限制状态
+ (void)cellularDataRestrictedState:(void (^) (CTCellularDataRestrictedState state))block;

@end

NS_ASSUME_NONNULL_END

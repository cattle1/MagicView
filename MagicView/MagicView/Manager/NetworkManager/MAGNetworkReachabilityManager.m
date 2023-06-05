//
//  ZTNetworkReachabilityManager.m
//  ZTCloud
//
//  Created by LL on 2021/4/24.
//

#import "MAGNetworkReachabilityManager.h"

#import "MAGImport.h"

@interface MAGNetworkReachabilityManager ()

@property (class, readonly) YYReachability *reachability;

@end

@implementation MAGNetworkReachabilityManager

+ (void)load {
    [mNotificationCenter addObserver:self selector:@selector(didFinishLaunching) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

+ (void)didFinishLaunching {
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        if (isMagicState) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [mNotificationCenter postNotificationName:MAGNetworkRestrictedStateDidChangeNotification object:nil userInfo:@{@"state" : @(state)}];
            });
        }
    };
    
    MAGNetworkReachabilityManager.reachability.notifyBlock = ^(YYReachability * _Nonnull reachability) {
        if (isMagicState) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [mNotificationCenter postNotificationName:MAGNetworkReachabilityStatusDidChangeNotification object:nil];
            });
        }
    };
}

+ (BOOL)isReachable {
    return MAGNetworkReachabilityManager.reachability.reachable;
}

+ (AFNetworkReachabilityStatus)networkReachabilityStatus {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    return manager.networkReachabilityStatus;
}

+ (void)cellularDataRestrictedState:(void (^) (CTCellularDataRestrictedState state))block {
#if TARGET_IPHONE_SIMULATOR
    mDispatchAsyncOnMainQueue(!block ?: block(kCTCellularDataNotRestricted));
#else
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    mWeakobj(cellularData)
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        mDispatchAsyncOnMainQueue(!block ?: block(state));
        weak_cellularData.cellularDataRestrictionDidUpdateNotifier = nil;
    };
#endif
}

+ (YYReachability *)reachability {
    static YYReachability *reachability;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reachability = [YYReachability reachability];
    });
    return reachability;
}

@end

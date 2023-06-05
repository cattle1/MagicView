//
//  MAGInitializeManager.m
//  MagicView
//
//  Created by LL on 2021/10/26.
//

#import "MAGInitializeManager.h"

#import <UserNotifications/UserNotifications.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/ASIdentifierManager.h>

#import "MAGImport.h"
#import "MAGIAPManager.h"
#import "MAGRechargeModel.h"
#import "MAGNetworkRequestManager.h"

static BOOL _isCanPayment = YES;
static BOOL _backgroundAudioPlayback = NO;
static BOOL _remoteNotifications = NO;
static BOOL _userTrackingUsageDescription = NO;
static BOOL _cameraAuthorization = NO;
static BOOL _photoLibraryAuthorization = NO;
static BOOL _photoLibraryAddAuthorization = NO;

static NSString *_notifyProtocolLink;
static NSString *_privacyProtocolLink;
static NSString *_logoffProtocolLink;
static NSString *_userProtocolLink;
static NSString *_vipProtocolLink;

@implementation MAGInitializeManager

+ (void)load {
    [mNotificationCenter addObserver:self selector:@selector(appDidFinishLaunchingNotification) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [mNotificationCenter addObserver:self selector:@selector(didBecomeActivieNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
}

+ (void)initialize {
    NSInteger startNumber = [NSUserDefaults.standardUserDefaults integerForKey:mStartNumberIdentifier];
    startNumber += 1;
    [NSUserDefaults.standardUserDefaults setInteger:startNumber forKey:mStartNumberIdentifier];
    
    NSDictionary *infoDictionary = NSBundle.mainBundle.infoDictionary;
    _userTrackingUsageDescription = [infoDictionary containsObjectForKey:@"NSUserTrackingUsageDescription"];
    _cameraAuthorization = [infoDictionary containsObjectForKey:@"NSCameraUsageDescription"];
    _photoLibraryAuthorization = [infoDictionary containsObjectForKey:@"NSPhotoLibraryUsageDescription"];
    _photoLibraryAddAuthorization = [infoDictionary containsObjectForKey:@"NSPhotoLibraryAddUsageDescription"];
    
    NSArray *backgroundModes = infoDictionary[@"UIBackgroundModes"];
    _remoteNotifications = [backgroundModes containsObject:@"remote-notification"];
    _backgroundAudioPlayback = [backgroundModes containsObject:@"audio"];
    
    
    [mNotificationCenter addObserver:self selector:@selector(firstViewDidLoadNotification) name:MAGBookMallViewDidLoadNotification object:nil];
    
#if mAutoLoginSwitch
    if (!MAGUserInfoManager.isLogin) {
        [MAGUserInfoManager touristLogin:[NSString m_UUIDString]];
    }
#endif
}

+ (void)startInitialized {
    [self mp_canMakePayments];
    [self mp_checkProtolLink];
}

+ (void)mp_canMakePayments {
    NSString *isCanPaymentString = [mUserDefault objectForKey:mCanPaymentsIdentifier];
    if ([isCanPaymentString isEqualToString:@"1"]) {
        _isCanPayment = YES;
        return;
    } else if ([isCanPaymentString isEqualToString:@"0"]) {
        _isCanPayment = NO;
        return;
    }
    
    [MAGNetworkRequestManager POST:mGoodsListLink
                        parameters:nil
                        modelClass:MAGRechargeModel.class
                         needCache:NO
                       autoRequest:YES
                   completionQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                           success:^(BOOL isSuccess, MAGRechargeModel * _Nullable t_model, BOOL isCache, MAGNetworkRequestModel * _Nonnull requestModel) {
        if (isSuccess) {
            NSArray *memberIdentifier = [t_model.memberList valueForKeyPath:mKEYPATH(t_model.memberList.firstObject, appleID)];
            NSArray *rechargeIdentifier = [t_model.rechargeList valueForKeyPath:mKEYPATH(t_model.rechargeList.firstObject, appleID)];
            
            // 排除掉苹果后台没有的商品
            [[MAGIAPManager shareInstance] verifyProductsWithIdentifiers:[memberIdentifier arrayByAddingObjectsFromArray:rechargeIdentifier] complete:^(NSArray<NSString *> * _Nonnull identifiers) {
                void (^purchaseStatusBlock)(NSArray<NSString *> *) = ^(NSArray<NSString *> *identifiers) {
                    _isCanPayment = identifiers.count > 0;
                    if (!_isCanPayment) {
                        mDispatchAsyncOnMainQueue([mNotificationCenter postNotificationName:MAGCanPaymentDidChangeNotification object:nil]);
                    }
                    [mUserDefault setObject:_isCanPayment ? @"1" : @"0" forKey:mCanPaymentsIdentifier];
                };
                
                if (identifiers.count > 0) {
                    !purchaseStatusBlock ?: purchaseStatusBlock(identifiers);
                } else {
                    // 检查固定商品是否存在
                
                    [[MAGIAPManager shareInstance] verifyProductsWithIdentifiers:MAGIAPManager.fixedGoodsIdentifier complete:purchaseStatusBlock];
                }
            }];
        } else {
            _isCanPayment = NO;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _isCanPayment = NO;
    }];
}

+ (void)mp_checkProtolLink {
    [MAGNetworkRequestManager POST:mCheckSettingLink parameters:nil modelClass:nil success:^(BOOL isSuccess, id  _Nullable t_model, BOOL isCache, MAGNetworkRequestModel * _Nonnull requestModel) {
        if (isSuccess) {
            NSDictionary *protocol = requestModel.data[@"protocol_list"];
            if (![protocol isKindOfClass:NSDictionary.class]) {
                protocol = [NSDictionary dictionary];
            }
            _vipProtocolLink = [NSString stringWithFormat:@"%@", protocol[@"vip"] ?: @""];
            _notifyProtocolLink = [NSString stringWithFormat:@"%@", protocol[@"notify"] ?: @""];
            _privacyProtocolLink = [NSString stringWithFormat:@"%@", protocol[@"privacy"] ?: @""];
            _logoffProtocolLink = [NSString stringWithFormat:@"%@", protocol[@"logoff"] ?: @""];
            _userProtocolLink = [NSString stringWithFormat:@"%@", protocol[@"user"] ?: @""];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


#pragma mark - Notification
+ (void)didBecomeActivieNotification {
    if (!isMagicState) return;
    
    // 自动请求通知权限
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (mUserTrackingUsageDescription) {
            if (@available(iOS 14, *)) {
                [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {}];
            }
        }
    });
    
    // 删除正式版内长按APP出现的功能按钮
    [[UIApplication sharedApplication] setShortcutItems:@[]];
}

+ (void)firstViewDidLoadNotification {
    if (!isMagicState) return;
    
    /*
     自动请求IDFA授权
     有时候正式版内可能要达到某个条件才会请求权限，例如IDFA权限有时候会被推迟到展示广告前请求，
     这样的话在审核的时候就不会弹出IDFA权限弹窗而导致被拒。
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (mRemoteNotifications) {
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {}];
        }
    });
}

+ (void)appDidFinishLaunchingNotification {
    if (!isMagicState) return;
    
    if (_isCanPayment) {
        [MAGIAPManager startManager];
    }
}


#pragma mark - Getter
+ (BOOL)isCanPayment {
    return _isCanPayment;
}

+ (NSString *)aesKey {
    static NSString *_aesKey;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _aesKey = [NSUserDefaults.standardUserDefaults objectForKey:mAESKeyIdentifier];
        if (mObjectIsEmpty(_aesKey)) {
            // 密钥长度只能是16、24、32
            _aesKey = [NSString m_createRandomStringWithNum:16];
            [NSUserDefaults.standardUserDefaults setObject:_aesKey forKey:mAESKeyIdentifier];
        }
    });
    return _aesKey;
}

+ (BOOL)backgroundAudioPlayback {
    return _backgroundAudioPlayback;
}

+ (BOOL)remoteNotifications {
    return _remoteNotifications;
}

+ (BOOL)userTrackingUsageDescription {
    return _userTrackingUsageDescription;
}

+ (BOOL)cameraAuthorization {
    return _cameraAuthorization;
}

+ (BOOL)photoLibraryAuthorization {
    return _photoLibraryAuthorization;
}

+ (BOOL)photoLibraryAddAuthorization {
    return _photoLibraryAddAuthorization;
}

+ (NSString *)vipProtocolLink {
    return _vipProtocolLink ?: @"";
}

+ (NSString *)notifyProtocolLink {
    return _notifyProtocolLink ?: @"";
}

+ (NSString *)privacyProtocolLink {
    return _privacyProtocolLink ?: @"";
}

+ (NSString *)logoffProtocolLink {
    return _logoffProtocolLink ?: @"";
}

+ (NSString *)userProtocolLink {
    return _userProtocolLink ?: @"";
}

+ (NSInteger)startNumber {
    return [NSUserDefaults.standardUserDefaults integerForKey:mStartNumberIdentifier];
}

@end

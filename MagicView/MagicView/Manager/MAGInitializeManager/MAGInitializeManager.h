//
//  MAGInitializeManager.h
//  MagicView
//
//  Created by LL on 2021/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAGInitializeManager : NSObject

/// APP是否有内购功能，默认是YES
@property (nonatomic, class, readonly) BOOL isCanPayment;

/// APP默认的AES密钥
@property (nonatomic, class, readonly) NSString *aesKey;

/// 是否打开了后台音频播放功能
@property (nonatomic, class, readonly) BOOL backgroundAudioPlayback;

/// 是否打开了后台推送功能
@property (nonatomic, class, readonly) BOOL remoteNotifications;

/// 是否获取了IDFA权限
@property (nonatomic, class, readonly) BOOL userTrackingUsageDescription;

/// 是否使用了相机功能
@property (nonatomic, class, readonly) BOOL cameraAuthorization;

/// 是否访问了相册权限
@property (nonatomic, class, readonly) BOOL photoLibraryAuthorization;

/// 是否使用了保存相册功能
@property (nonatomic, class, readonly) BOOL photoLibraryAddAuthorization;


/// 用户服务协议
@property (nonatomic, class, readonly) NSString *notifyProtocolLink;

/// 隐私政策
@property (nonatomic, class, readonly) NSString *privacyProtocolLink;

//  注销协议
@property (nonatomic, class, readonly) NSString *logoffProtocolLink;

//  用户协议
@property (nonatomic, class, readonly) NSString *userProtocolLink;

//  会员说明协议
@property (nonatomic, class, readonly) NSString *vipProtocolLink;
/// APP启动次数
/// @discussion 只记录壳子的启动次数；
///             如果启动时是壳子，或者在APP杀死之前切换过壳子则记一次启动；
///             如果启动时是正式版，并且没有切换过壳则不记为一次启动。
@property (nonatomic, class, readonly) NSInteger startNumber;


+ (void)startInitialized;

@end

NS_ASSUME_NONNULL_END

//
//  MAGSwitchConfig.h
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#ifndef MAGSwitchConfig_h
#define MAGSwitchConfig_h

#import "MAGInitializeManager.h"
#import "MAGSettingConfig.h"

#if __has_include("WXApi.h")
#import "WXApi.h"
#endif

#if __has_include("TencentOpenAPI/TencentOAuth.h")
#import "TencentOpenAPI/TencentOAuth.h"
#endif

#pragma mark - 手动开关
/**
 当设置为1时：首次打开APP会自动登录，反之不会自动登录。
 如果用户手动注销账号，那么下次打开APP不会自动登录。
 */
#define mAutoLoginSwitch 1

#pragma mark - 自动开关
// 是否打开了后台音频播放功能
#define mBackgroundAudioPlayback MAGBackgroundAudioPlayback()
UIKIT_STATIC_INLINE BOOL MAGBackgroundAudioPlayback(void) {
    return MAGInitializeManager.backgroundAudioPlayback;
}

// 是否打开了远程推送功能
#define mRemoteNotifications MAGRemoteNotifications()
UIKIT_STATIC_INLINE BOOL MAGRemoteNotifications(void) {
    return MAGInitializeManager.remoteNotifications;
}

// 是否开启了获取IDFA权限
#define mUserTrackingUsageDescription MAGUserTrackingUsageDescription()
UIKIT_STATIC_INLINE BOOL MAGUserTrackingUsageDescription(void) {
    return MAGInitializeManager.userTrackingUsageDescription;
}

// 是否使用了相机功能
#define mCameraAuthorization MAGCameraAuthorization()
UIKIT_STATIC_INLINE BOOL MAGCameraAuthorization(void) {
    return MAGInitializeManager.cameraAuthorization;
}

// 是否访问了相册权限
#define mPhotoLibraryAuthorization MAGPhotoLibraryAuthorization()
UIKIT_STATIC_INLINE BOOL MAGPhotoLibraryAuthorization(void) {
    return MAGInitializeManager.photoLibraryAuthorization;
}

// 是否使用了保存相册功能
#define mPhotoLibraryAddAuthorization MAGPhotoLibraryAddAuthorization()
UIKIT_STATIC_INLINE BOOL MAGPhotoLibraryAddAuthorization(void) {
    return MAGInitializeManager.photoLibraryAddAuthorization;
}

// 是否有穿山甲广告
#define mBUASwitch MAGBUASwitch()
UIKIT_STATIC_INLINE BOOL MAGBUASwitch(void) {
    static BOOL result;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if __has_include("BUAdSDK/BUAdSDK.h")
        result = !mObjectIsEmpty(mPangolinAppKey);
#else
        result = NO;
#endif
    });
    return result;
}

// 是否有第3方广告
#define mThirdPartyAdSwith MAGThirdPartyAD()
UIKIT_STATIC_INLINE BOOL MAGThirdPartyAD(void) {
    return mBUASwitch;
}

// 是否有内购功能
#define mIsCanPayment MAGIsCanPayment()
UIKIT_STATIC_INLINE BOOL MAGIsCanPayment(void) {
    return MAGInitializeManager.isCanPayment;
}

// 本地付费功能开关(开启状态下所有章节内容都需要购买)
#define mLocalPaymentSwitch MAGLocalPayment()
UIKIT_STATIC_INLINE BOOL MAGLocalPayment(void) {
    return mIsCanPayment;
}

// 接口加密开关
#define mInterfaceEncryptionSwitch MAGInterfaceEncryption()
UIKIT_STATIC_INLINE BOOL MAGInterfaceEncryption(void) {
    static BOOL result;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        result = (kEncryptionKey.length > 0 && kEncryptionSecret.length > 0);
    });
    return result;
}

// IO读写加密开关(开启状态下所有保存的数据都会进行加密)
#define mIOEncryptionSwitch !TARGET_IPHONE_SIMULATOR

// 是否集成了微信登录
#define mWechatLoginSwitch MAGWechatLoginSwitch()
UIKIT_STATIC_INLINE BOOL MAGWechatLoginSwitch(void) {
#if __has_include("WXApi.h")
    return [WXApi isWXAppInstalled];
#else
    return NO;
#endif
}

// 是否集成了QQ登录
#define mQQLoginSwitch MAGQQLoginSwitch()
UIKIT_STATIC_INLINE BOOL MAGQQLoginSwitch(void) {
#if __has_include("TencentOpenAPI/TencentOAuth.h")
    return [TencentOAuth iphoneQQInstalled];
#else
    return NO;
#endif
}

#endif /* MAGSwitchConfig_h */

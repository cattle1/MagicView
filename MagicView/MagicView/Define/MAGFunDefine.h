//
//  MAGFunDefine.h
//  MagicView
//
//  Created by LL on 2021/7/6.
//

#ifndef MAGFunDefine_h
#define MAGFunDefine_h

#import <sys/utsname.h>

#import "MAGFrameDefine.h"
#import "MAGInitializeManager.h"


typedef void(^MAGDelayedBlockHandle)(BOOL isCancel);

/// 将 m_dispatch_after 的任务标记为已取消，并在合适的时机释放它
/// @param delayedHandle 需要取消的任务
__attribute__((unused)) static void m_cancel_dispatch_after(MAGDelayedBlockHandle delayedHandle) {
    if (delayedHandle == nil) return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        delayedHandle(YES);
    });
}

/// dispatch_after 的可取消版本
///
/// @discussion 请使用 m_cancel_dispatch_after 函数在倒计时结束前取消它
///
/// @note block将会在主线程执行
///
/// @code
///
/// MAGDelayedBlockHandle handle = m_dispatch_after(2.0, ^{
///
///     ...
///
/// });
///
/// m_cancel_dispatch_after(handle);
/// @endcode
__attribute__((unused)) static MAGDelayedBlockHandle m_dispatch_after(NSTimeInterval seconds, dispatch_block_t block) {
    if (block == nil) return nil;
    
    __block dispatch_block_t blockToExecute = [block copy];
    __block MAGDelayedBlockHandle delayHandleCopy = nil;
    
    MAGDelayedBlockHandle delayHandle = ^(BOOL isCancel) {
        if (!isCancel && blockToExecute) {
            blockToExecute();
        }
        
        blockToExecute = nil;
        delayHandleCopy = nil;
    };
    
    delayHandleCopy = [delayHandle copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        !delayHandleCopy ?: delayHandleCopy(NO);
    });
    
    return delayHandleCopy;
}

/// 判断是不是空对象或nil
/// @discussion @“”、@[]、@{}、数字0以及任何 length 或 count 为0都属于空对象
UIKIT_STATIC_INLINE BOOL mObjectIsEmpty(id object) {
    if (([object respondsToSelector:@selector(length)] && [(NSData *)object length] > 0) ||
        ([object respondsToSelector:@selector(count)] && [(NSArray *)object count] > 0) ||
        ([object respondsToSelector:@selector(floatValue)] && [(id)object floatValue] != 0.0)) {
        return NO;
    }
    return YES;
}

UIKIT_STATIC_INLINE NSString *mNSStringFromInteger(NSInteger i) {
    return [NSString stringWithFormat:@"%zd", i];
}

UIKIT_STATIC_INLINE NSString *mNSStringFromFloat(CGFloat f) {
    NSString *string = [NSString stringWithFormat:@"%f", f];
    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:string];
    return [number stringValue];
}

/// 返回一个随机整数，包含起始值和终点值
UIKIT_STATIC_INLINE NSInteger mRandomInteger(NSInteger from, NSInteger to) {
    return ((NSInteger)(from + (arc4random() % (to - from + 1))));
}

/// 返回一个随机浮点数，包含起始值和终点值
UIKIT_STATIC_INLINE CGFloat mRandomFloat(CGFloat from, CGFloat to) {
    NSInteger precision = 100;
    CGFloat subtraction = to - from;
    subtraction = ABS(subtraction);
    subtraction *= precision;
    CGFloat randomNumber = arc4random() % ((int)subtraction + 1);
    randomNumber /= precision;
    return MIN(from, to) + randomNumber;
}


#pragma mark - 功能宏
// 在主线程中执行一段代码并返回执行结果(一个id对象)，可以在主线程中使用
#define mRCodeSync(x) ({\
    id __block temp;\
    if ([NSThread isMainThread]) {\
        temp = x;\
    } else {\
        dispatch_semaphore_t signal = dispatch_semaphore_create(0);\
        dispatch_async(dispatch_get_main_queue(), ^{\
            temp = x;\
            dispatch_semaphore_signal(signal);\
        });\
        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);\
    }\
    temp;\
})

// 在主线程中执行一段代码，可以在主线程中使用
#define mCodeSync(x) ({\
    if ([NSThread isMainThread]) {\
        x;\
    } else {\
        dispatch_semaphore_t signal = dispatch_semaphore_create(0);\
        dispatch_async(dispatch_get_main_queue(), ^{\
            x;\
            dispatch_semaphore_signal(signal);\
        });\
        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);\
    }\
})

// 使用异步方式在主线程中执行
#define mDispatchAsyncOnMainQueue(x)\
{\
    dispatch_async(dispatch_get_main_queue(), ^{\
        x;\
    });\
}

// 使用异步方式在子线程中执行
#define mDispatchAsyncOnOtherQueue(x)\
{\
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{\
        x;\
    });\
}

// 使用同步方式在子线程中执行
#define mDispatchSyncOnOtherQueue(x)\
{\
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{\
        x;\
    });\
}

/*
 将属性名称转换为字符串
 
 示例代码
 
 mKEYPATH(self, name) => @"name"
 
 不要在GET方法中调用自身(这会造成死循环)，如下代码是错误示例
 
 - (NSString *)name {
    return mKEYPATH(self, name);
 }
 */
#define mKEYPATH(objc, property) ((void)objc.property, @(#property))

// 弱引用声明
#define mWeakobj(object) __weak typeof(object) weak##_##object = object;

// 强引用声明
#define mStrongobj(object) __strong typeof(object) strong##_##object = object;

// APP默认AES密钥
#define mAESKey MAGAESKey()
UIKIT_STATIC_INLINE NSString *MAGAESKey(void) {
    return MAGInitializeManager.aesKey;
}

// 获取当前时间戳(单位：毫秒)
#define mTimestampMillisecond ((long)([[NSDate date] timeIntervalSince1970] * 1000))

// 获取当前时间戳字符串(单位：毫秒)
#define mTimestampMillisecondString NSStringFromInteger(mTimestampMillisecond)

// 获取当前时间戳(单位：秒)
#define mTimestampSecond ((NSInteger)(mTimestampMillisecond / 1000))

// 获取当前时间戳字符串(单位：秒)
#define mTimestampSecondString mNSStringFromInteger(mTimestampSecond)

// 快速禁用当前类的其他初始化方法
#define mSingleClass \
+ (instancetype)allocWithZone:(struct _NSZone *)zone UNAVAILABLE_ATTRIBUTE;\
+ (instancetype)alloc UNAVAILABLE_ATTRIBUTE;\
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;


#pragma mark - APP相关宏
// APP的应用下载链接
#define mAppStoreLink MAGAppStoreLink()
UIKIT_STATIC_INLINE NSString *MAGAppStoreLink(void) {
    static NSString *_appstoreLink;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appstoreLink = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8", Apple_ID];
    });
    return _appstoreLink;
}

// 获取APP的版本信息(字符串类型)
#define mAppVersion MAGAppVersion()
UIKIT_STATIC_INLINE NSString *MAGAppVersion(void) {
    static NSString *_appVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appVersion = [NSString stringWithString:NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"]];
    });
    return _appVersion;
}

// 获取APP名称
#define mAppName MAGAppName()
UIKIT_STATIC_INLINE NSString *MAGAppName(void) {
    static NSString *_appName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appName = NSBundle.mainBundle.localizedInfoDictionary[@"CFBundleDisplayName"];
        if (mObjectIsEmpty(_appName)) {
            _appName = NSBundle.mainBundle.infoDictionary[@"CFBundleDisplayName"];
        }
    });
    return _appName;
}

// 获取APP的Logo图片名称
#define mAppLogoName MAGAppLogoName()
UIKIT_STATIC_INLINE NSString *MAGAppLogoName(void) {
    static NSString *_appLogoName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appLogoName = [[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    });
    return _appLogoName;
}

#define mBundleIdenfier MAGBundleIdentifier()
UIKIT_STATIC_INLINE NSString * MAGBundleIdentifier(void) {
    return [[NSBundle mainBundle] bundleIdentifier];
}

#define mSystemVersion MAGSystemVersion()
UIKIT_STATIC_INLINE NSString * MAGSystemVersion(void) {
    return [[UIDevice currentDevice] systemVersion];
}

#define mDeviceArchitecture MAGDeviceArchitecture()
UIKIT_STATIC_INLINE NSString *MAGDeviceArchitecture(void) {
    static NSString *_deviceArchitecture;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct utsname systemInfo;
        uname(&systemInfo);
        _deviceArchitecture = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    });
    return _deviceArchitecture;
}

// 判断是不是刘海屏
#define mIsiPhoneX (mSafeAreaInsertBottom > 0)

// 获取当前显示的TabBarController
#define mCurrentTabBarController [MAGUITools currentTabBarController]

// 获取当前显示的NavigationController
#define mCurrentNavigationController [MAGUITools currentNavigationController]

// 获取当前显示的ViewController
#define mCurrentViewController [MAGUITools currentViewController]

// 获取当前显示的View
#define mCurrentView [MAGUITools currentView]

// 获取APP主Window
#define mMainWindow ((UIWindow *)mRCodeSync(UIApplication.sharedApplication.delegate.window))

// 获取屏幕最顶部的Window
#define mTopWindow MAGGetTopWindon()
UIKIT_STATIC_INLINE UIWindow *MAGGetTopWindon(void) {
    UIWindow *topWindow = [YYTextKeyboardManager defaultManager].keyboardWindow;
    if (topWindow == nil ||
        topWindow.isHidden ||
        topWindow.alpha == 0.0 ||
        CGRectEqualToRect(topWindow.frame, CGRectZero)) {
        topWindow = mMainWindow;
    }
    return topWindow;
}

#endif /* MAGFunDefine_h */

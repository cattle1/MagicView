//
//  MAGNotificationDefine.h
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#ifndef MAGNotificationDefine_h
#define MAGNotificationDefine_h

/**
 * 除非注释有说明是在主线程中发送，否则所有通知默认都是在当前线程中发送。
 */

#pragma mark - APP相关通知

// 通知观察者需要切换到过审壳状态(请不要修改通知名称，因为正式版需要用到)
#define MAGSwitchMagicStateNotification @"MAGSwitchMagicStateNotification"

// 通知观察者需要切换到正式版(请不要修改通知名称，因为正式版需要用到，壳内只负责发送)
#define MAGSwitchFormalStateNotification @"MAGSwitchFormalStateNotification"

// 通知观察者书城首页已经加载完成(有时候一些操作需要延迟到页面展示完成后在进行，例如IDFA授权弹窗经常被审核员反驳看不到)
#define MAGBookMallViewDidLoadNotification @"MAGBookMallViewDidLoadNotification"

/**
 * 通知观察者APP的网络限制状态已发生改变。
 * @discussion 新的限制状态字段为"state"，类型为BOOL。
 *             通知将会在主线程中发送。
 */
#define MAGNetworkRestrictedStateDidChangeNotification @"MAGNetworkRestrictedStateDidChangeNotification"

/**
 * 通知观察者APP的网络可达性已发生改变。
 * @discussion 通知将会在主线程中发送。
 */
#define MAGNetworkReachabilityStatusDidChangeNotification @"MAGNetworkReachabilityStatusDidChangeNotification"

/**
 * 通知观察者APP的语言环境已发生变化。
 * @discussion 通知将会在主线程中发送。
 */
#define MAGLanguageDidChangeNotification @"MAGLanguageDidChangeNotification"


#pragma mark - 用户相关通知

/**
 * 通知观察者用户登录成功。
 * @discussion 通知将会在主线程中发送。
 */
#define MAGUserLoginSuccessNotification @"MAGUserLoginSuccessNotification"

// 通知观察者用户充值成功
#define MAGUserPurchaseSuccessNotification @"MAGUserPurchaseSuccessNotification"

/**
 * 通知观察者APP内购状态已发生变化，请使用 mIsCanPayment 获取最新内购状态
 * @discussion 通知将会在主线程中发送。
 */
#define MAGCanPaymentDidChangeNotification @"MAGCanPaymentDidChangeNotification"

// 通知观察者用户已退出登录，通知会在主线程中发送。
#define MAGUserDidLogoutNotification @"MAGUserDidLogoutNotification"

// 通知观察者用户注销账号成功，通知会在主线程中发送。
#define MAGUserAccountCancellationSuccessNotification @"MAGUserAccountCancellationSuccessNotification"


#pragma mark - 小说阅读器相关通知

// 通知观察者小说阅读器的翻页动画已发生变化
#define MAGBookReaderAnimateDidChangeNotification @"MAGBookReaderAnimateDidChangeNotification"

// 通知观察者小说阅读器的背景样式已发生变化
#define MAGBookReaderBackgroundImageDidChangeNotification @"MAGBookReaderBackgroundImageDidChangeNotification"

// 通知观察者小说阅读器的字体大小已发生变化
#define MAGBookReaderTextFontSizeDidChangeNotification @"MAGBookReaderTextFontSizeDidChangeNotification"

// 通知观察者需要刷新小说阅读器，需要指定 object 刷新阅读器
#define MAGBookReaderNeedRefreshNotification @"MAGBookReaderNeedRefreshNotification"

#endif /* MAGNotificationDefine_h */

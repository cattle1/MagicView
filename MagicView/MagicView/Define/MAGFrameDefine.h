//
//  MAGFrameDefine.h
//  MagicView
//
//  Created by LL on 2021/7/6.
//

#ifndef MAGFrameDefine_h
#define MAGFrameDefine_h

#import "MAGUITools.h"

#pragma mark - 固定单位
static CGFloat const mMargin = 20.0f;

static CGFloat const mMoreHalfMargin = 15.0f;

static CGFloat const mHalfMargin = 10.0f;

static CGFloat const mQuarterMargin = 5.0f;

static CGFloat const mViewMargin = 8.0f;

static CGFloat const mLineHeight = 0.4f;

static CGFloat const miPhone6W = 375.0f;

static CGFloat const miPhone6H = 667.0f;


#pragma mark - APP相关
// 顶部不安全区域的高度
#define mSafeAreaInsertTop MAGUITools.safeAreaInsertTop

// 底部不安全区域的高度
#define mSafeAreaInsertBottom MAGUITools.safeAreaInsertBottom

// 导航栏总高度
#define mNavBarHeight (mNavBarSafeAreaHeight + mSafeAreaInsertTop)

// 导航栏安全区域高度
#define mNavBarSafeAreaHeight MAGUITools.navigationBarHeight

// tabBar高度
#define mTabBarHeight MAGUITools.tabBarHeight

// 返回当前屏幕和iPhone6屏幕宽的比例
#define mScaleW (kScreenWidth / miPhone6W)

// 返回当前屏幕和iPhone6屏幕高的比例
#define mScaleH (kScreenHeight / miPhone6H)

/// 计算当前屏幕需要的宽度
UIKIT_STATIC_INLINE CGFloat mScaleWidth(CGFloat width) {
    return width * mScaleW;
}

/// 计算当前屏幕需要的高度
UIKIT_STATIC_INLINE CGFloat mScaleHeight(CGFloat height) {
    return height *mScaleH;
}

/// 计算一个比例值，返回(a * b  /  c)
UIKIT_STATIC_INLINE CGFloat mGeometricValue(CGFloat a, CGFloat b, CGFloat c) {
    return a * b / c;
}

#endif /* MAGFrameDefine_h */

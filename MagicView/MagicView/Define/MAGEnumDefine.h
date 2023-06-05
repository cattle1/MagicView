//
//  MAGEnumDefine.h
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#ifndef MAGEnumDefine_h
#define MAGEnumDefine_h

typedef NS_ENUM(NSInteger, MAGMineSubViewStyle) {// 个人中心的子页面样式
    MAGMineSubViewStyleRecharge       = 0,/**< 充值中心页面*/
    MAGMineSubViewStyleRechargeRecord = 1,/**< 充值历史页面*/
    MAGMineSubViewStyleFeedback       = 2,/**< 帮助反馈页面*/
    MAGMineSubViewStylePraise         = 3,/**< 好评*/
    MAGMineSubViewStyleReadRecord     = 4,/**< 阅读记录页面*/
    MAGMineSubViewStyleDarkMode       = 6,/**< 深色模式页面*/
    MAGMineSubViewStyleAbout          = 7,/**< 关于我们页面*/
    MAGMineSubViewStyleDeleteAccount  = 8,/**< 注销账号页面*/
};

#pragma mark - 小说阅读器相关枚举
/// 小说阅读器的翻页动画
typedef NS_ENUM(NSInteger, MBookReaderAnimate) {
    MBookReaderAnimateHorizontalPageCurl = 0,/**< 水平仿真翻页*/
};

/// 小说阅读器背景样式
typedef NS_ENUM(NSInteger, MBookReaderBackgroundStyle) {
    MBookReaderBackgroundStyleWhite      = 0,/**< 白色背景*/
    MBookReaderBackgroundStyleGray       = 1,/**< 极光灰背景*/
    MBookReaderBackgroundStyleBlack      = 2,/**< 暗夜黑背景*/
    MBookReaderBackgroundStyleKraftPaper = 3,/**< 牛皮纸背景*/
    MBookReaderBackgroundStyleYellow     = 4,/**< 杏仁黄背景*/
    MBookReaderBackgroundStyleBrown      = 5,/**< 秋叶褐背景*/
    MBookReaderBackgroundStyleRed        = 6,/**< 胭脂红背景*/
    MBookReaderBackgroundStyleGreen      = 7,/**< 青草绿背景*/
    MBookReaderBackgroundStyleBlue       = 8,/**< 海天蓝背景*/
    MBookReaderBackgroundStylePurple     = 9,/**< 葛巾紫背景*/
};

#endif /* MAGEnumDefine_h */

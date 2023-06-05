//
//  MAGSettingConfig.h
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#ifndef MAGSettingConfig_h
#define MAGSettingConfig_h

#import "MAGEnumDefine.h"

//#pragma mark 小说阅读器
/// 小说阅读器翻页默认动画
static const MBookReaderAnimate mBookReaderDefaultAnimate = MBookReaderAnimateHorizontalPageCurl;

//
/// 小说阅读器背景默认样式
static const MBookReaderBackgroundStyle mBookReaderBackgroundDefaultStyle = MBookReaderBackgroundStyleYellow;


#pragma mark - 以下内容一般不用修改
// 章节本地价格
static const NSInteger mChapterPrice = 1;

/// HUD停留时长
static const NSTimeInterval mHUDDuration = 2.0;

/// HUD宽限时间
static const NSTimeInterval mHUDGraceTime = 0.5;

/// HUD最少显示时长
static const NSTimeInterval mHUDMinShowTime = 0.5;

#endif /* MAGSettingConfig_h */

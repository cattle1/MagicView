//
//  MAGBookReaderMenuView.h
//  MagicView
//
//  Created by LL on 2021/8/30.
//

#import "MAGView.h"

#import "MAGBookReaderManager.h"
#import "MAGBookManager.h"
#import "MAGBookListenManager.h"

@class MAGBookCatalogListModel;

NS_ASSUME_NONNULL_BEGIN

@interface MAGBookReaderMenuView : MAGView<MAGBookListenDelegate>

@property (nonatomic, readonly, nullable) UIColor *menuBackgroundColor;

@property (nonatomic, readonly, nullable) UIColor *menuTintColor;

@property (nonatomic, readonly) MAGBookManager *bookManager;

@property (nonatomic, readonly) MAGBookListenManager *listenManager;

@property (nonatomic, readonly) UIView *topView;

@property (nonatomic, readonly) UIView *bottomView;

/// 工具栏
@property (nonatomic, readonly) UIView *toolBar;

@property (nonatomic, readonly) UIImageView *backImageView;

@property (nonatomic, readonly) NSDictionary *clickAttributes;


@property (nonatomic, copy) void(^switchChapterBlock)(MAGBookCatalogListModel *catalogModel);

/// 告诉代理当前正在阅读的章节内容已发生变化
@property (nonatomic, copy) void(^listenWillSpeakRangeOfSpeechString)(NSInteger chapterIndex, NSInteger pageIndex, NSRange characterRange);

/// 告诉代理即将开始阅读新的一页内容
@property (nonatomic, copy) void(^listenDidStartNewSpeechUtterance)(NSInteger chapterIndex, NSInteger pageIndex);

/// 告诉代理已经停止了阅读
@property (nonatomic, copy) void(^listenBookDidFinishSpeechUtterance)(void);

+ (instancetype)menuViewWithBookManager:(MAGBookManager *)bookManager;

- (void)show;

- (void)hide;

- (BOOL)isShow;

- (void)startListening;

- (void)pushBookCatalogViewController;

/// 通知观察者小说阅读器的背景已发生改变
- (void)backgroundImageDidChangeNotification;

@end

NS_ASSUME_NONNULL_END

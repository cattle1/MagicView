//
//  MAGBookContentView.h
//  MagicView
//
//  Created by LL on 2021/7/16.
//

#import "MAGView.h"

#import "MAGBookReaderManager.h"
#import "MAGBookPageContentModel.h"
#import "MAGBookManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGBookContentView : MAGView {
    YYTextView *_contentView;
    UIView *_topView;
    UIView *_bottomView;
    MAGBookManager * _Nullable _bookManager;
}

@property (nonatomic, strong, nullable) MAGBookPageContentModel *pageContent;

@property (nonatomic, assign, readonly) BOOL autoUpdate;


/// @param autoUpdate 是否需要自动更新阅读记录，如果设置为YES那么内部会在显示内容的同时更新阅读记录
+ (instancetype)bookContentViewWithPageContent:(nullable MAGBookPageContentModel *)pageContent
                             bookManager:(nullable MAGBookManager *)bookManager
                              autoUpdate:(BOOL)autoUpdate;

mSingleClass

/// 通知观察者小说阅读器的背景已发生改变
- (void)backgroundImageDidChangeNotification;

/// 将指定章节正在阅读的区域内容渲染为高亮背景色
- (void)speakRangeOfSpeechRange:(NSRange)characterRange chapterIndex:(NSInteger)chapterIndex pageIndex:(NSInteger)pageIndex;

/// 用户已停止听书，需要删除高亮背景色
- (void)didFinishSpeechUtterance;

@end

NS_ASSUME_NONNULL_END

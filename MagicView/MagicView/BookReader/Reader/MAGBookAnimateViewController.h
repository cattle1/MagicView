//
//  MAGBookAnimateViewController.h
//  MagicView
//
//  Created by LL on 2021/7/16.
//

#import "MAGViewController.h"

#import "MAGBookManager.h"
#import "MAGBookReaderManager.h"
#import "MAGBookContentViewController.h"
#import "MAGBookContentView.h"

@protocol MAGBookAnimateViewControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

/// 这是小说阅读器各种翻页动画的基类，如果需要新增翻页动画必须继承它
@interface MAGBookAnimateViewController : MAGViewController {
    NSString *_bookID;
    NSString *_chapterID;
    NSInteger _chapterIndex;
}

@property (nonatomic, readonly) NSString *bookID;

@property (nonatomic, readonly) MAGBookManager *bookManager;

@property (nonatomic, readonly) UIImageView *backgroundImageView;

@property (nonatomic, readonly) NSDictionary *clickAttributeds;

@property (nonatomic, weak) id<MAGBookAnimateViewControllerDelegate> delegate;

/// 唯一初始化方法
/// @param chapterIndex 如果小于0则以 chapterID 为准
/// @discussion chapterID 和 chapterIndex 如果同时符合条件会以 chapterID 为准
+ (instancetype)bookReaderWithAnimate:(MBookReaderAnimate)animate
                               bookID:(NSString *)bookID
                            chapterID:(nullable NSString *)chapterID
                         chapterIndex:(NSInteger)chapterIndex;

/// 取消翻页
- (void)cancelTurnPage;

/// 判断正在阅读的是不是第一页
- (BOOL)isFirstPage;

/// 判断正在阅读的是不是最后一页
- (BOOL)isLastPage;

/// 根据阅读记录获取内容，如果没有阅读记录则获取首页的内容
/// @param autoUpdate 是否需要自动更新阅读记录
- (void)getCurrentPageContent:(mBookPageContentBlock)block autoUpdate:(BOOL)autoUpdate;

/// 获取上一页的内容
/// @param autoUpdate 是否需要自动更新阅读记录
- (void)getAfterPageContent:(mBookPageContentBlock)block autoUpdate:(BOOL)autoUpdate;

/// 获取下一页的内容
/// @param autoUpdate 是否需要自动更新阅读记录
- (void)getBeforePageContent:(mBookPageContentBlock)block autoUpdate:(BOOL)autoUpdate;

/// 根据章节索引获取指定章节与页码的内容
/// @param autoUpdate 是否需要自动更新阅读记录
- (void)getPageContentWithChapterIndex:(NSInteger)chapterIndex pageIndex:(NSInteger)pageIndex complte:(mBookPageContentBlock)block autoUpdate:(BOOL)autoUpdate;

/// 根据章节ID获取指定章节与页码的内容
/// @param autoUpdate 是否需要自动更新阅读记录
- (void)getPageContentWithChapterID:(NSString *)chapterID pageIndex:(NSInteger)pageIndex complte:(mBookPageContentBlock)block autoUpdate:(BOOL)autoUpdate;

/// 根据阅读记录从本地获取内容，如果没有阅读记录则获取首页的内容，如果本地不存在则返回nil
/// @param autoUpdate 是否需要自动更新阅读记录
- (nullable MAGBookPageContentModel *)getCurrentPageContentWithAutoUpdate:(BOOL)autoUpdate;

/// 从本地获取上一页的内容，如果本地不存在则返回nil
/// @param autoUpdate 是否需要自动更新阅读记录
- (nullable MAGBookPageContentModel *)getAfterPageContentWithAutoUpdate:(BOOL)autoUpdate;

/// 从本地获取下一页的内容，如果本地不存在则返回nil
/// @param autoUpdate 是否需要自动更新阅读记录
- (nullable MAGBookPageContentModel *)getBeforePageContentWithAutoUpdate:(BOOL)autoUpdate;

/// 根据章节索引从本地获取指定章节指定页码的内容，如果本地不存在则返回nil
/// @param autoUpdate 是否需要自动更新阅读记录
- (nullable MAGBookPageContentModel *)getPageContentWithChapterID:(NSString *)chapterID pageIndex:(NSInteger)pageIndex autoUpdate:(BOOL)autoUpdate;

/// 根据章节ID从本地获取指定章节和页码的内容，如果本地不存在则返回nil
/// @param autoUpdate 是否需要自动更新阅读记录
- (nullable MAGBookPageContentModel *)getPageContentWithChapterIndex:(NSInteger)chapterIndex pageIndex:(NSInteger)pageIndex autoUpdate:(BOOL)autoUpdate;

- (void)switchChapterWithChpaterID:(NSString *)chapterID;

/// 跳转到下一页(用于听书自动播放触发的翻页)
- (void)jumpToTheNextPage:(NSInteger)chapterIndex pageIndex:(NSInteger)pageIndex;

/// 将指定章节正在阅读的区域内容渲染为高亮背景色
- (void)speakRangeOfSpeechRange:(NSRange)characterRange chapterIndex:(NSInteger)chapterIndex pageIndex:(NSInteger)pageIndex;

/// 用户已停止听书，需要删除高亮背景色
- (void)didFinishSpeechUtterance;

/// 通知观察者小说阅读器的背景已发生改变
- (void)backgroundImageDidChangeNotification;

/// 通知观察者需要刷新小说阅读器
- (void)refreshBookReaderNotification;

@end


@protocol MAGBookAnimateViewControllerDelegate <NSObject>

/// 通知观察者用户点击了菜单栏
- (void)bookAnimateViewControllerDidClickMenuView:(MAGBookAnimateViewController *)viewController;

@end

NS_ASSUME_NONNULL_END

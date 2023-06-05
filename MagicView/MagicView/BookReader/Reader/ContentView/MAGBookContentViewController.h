//
//  MAGBookContentViewController.h
//  MagicView
//
//  Created by LL on 2021/7/16.
//

#import "MAGViewController.h"

#import "MAGBookManager.h"

@class MAGBookPageContentModel;

NS_ASSUME_NONNULL_BEGIN

@interface MAGBookContentViewController : MAGViewController

@property (nonatomic, strong, nullable) MAGBookPageContentModel *pageContent;

/// @param autoUpdate 是否需要自动更新阅读记录，如果设置为YES那么内部会在显示内容的同时更新阅读记录
/// @param pageContent 当前这一页的内容
/// @param bookManager 如果autoUpdate为NO可以传nil
+ (instancetype)contentViewControllerWithAutoUpdate:(BOOL)autoUpdate
                                        pageContent:(nullable MAGBookPageContentModel *)pageContent
                                        bookManager:(nullable MAGBookManager *)bookManager;

mSingleClass

/// 根据 ViewController 或 MAGBookPageContentModel 生成一个适用于仿真翻页背面的UIViewController实例对象
+ (UIViewController *)bookBackViewControllerWithObj:(id)obj;

/// 将指定章节正在阅读的区域内容渲染为高亮背景色
- (void)speakRangeOfSpeechRange:(NSRange)characterRange chapterIndex:(NSInteger)chapterIndex pageIndex:(NSInteger)pageIndex;

/// 用户已停止听书，需要删除高亮背景色
- (void)didFinishSpeechUtterance;

@end

NS_ASSUME_NONNULL_END

//
//  MAGBookReaderManager.h
//  MagicView
//
//  Created by LL on 2021/7/16.
//

#import <Foundation/Foundation.h>

#import "MAGBookReadModel.h"

@class MAGBookPageContentModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ _Nullable mBookPageContentBlock)(MAGBookPageContentModel * _Nullable pageContent);

@interface MAGBookManager : NSObject

@property (nonatomic, copy, readonly) NSString *bookID;

@property (nonatomic, copy, readonly) NSString *bookName;

@property (nonatomic, copy, readonly) NSString *bookCover;

@property (nonatomic, assign, readonly) NSInteger chapterCount;

@property (nonatomic, strong, readonly) MAGBookReadModel *readInfo;


+ (nullable instancetype)bookManagerWithBookID:(NSString *)bookID;

/// 获取听书需要的章节内容
- (NSArray<NSString *> *)listenStrings;

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

@end

NS_ASSUME_NONNULL_END

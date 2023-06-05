//
//  MAGBookDownloadManager.h
//  MagicView
//
//  Created by LL on 2021/8/27.
//

#import <Foundation/Foundation.h>

#import "MAGBookCatalogModel.h"
#import "MAGBookChapterContentModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^mBookContentCompleteBlock)(MAGBookChapterContentModel * _Nullable chapterContent);

@interface MAGBookDownloadManager : NSObject

@property (nonatomic, readonly) NSString *bookID;

@property (nonatomic, readonly, nullable) MAGBookCatalogModel *bookCatalog;

/// 通知观察者小说目录已发生改变
@property (nonatomic, copy) void(^bookCatalogDidChange)(MAGBookCatalogModel *catalogModel);

+ (nullable instancetype)bookDownloadManagerWithBookID:(NSString *)bookID;

/// complete会在主线程中回调
- (void)getChapterContentWithChapterID:(NSString *)chaterID complete:(mBookContentCompleteBlock)complete;

/// complete会在主线程中回调
- (void)getChapterContentWithChapterIndex:(NSUInteger)chapterIndex complete:(mBookContentCompleteBlock)complete;

- (nullable MAGBookChapterContentModel *)getChapterContentWithChapterID:(NSString *)chapterID;

- (nullable MAGBookChapterContentModel *)getChapterContentWithChapterIndex:(NSUInteger)chapterIndex;

@end

NS_ASSUME_NONNULL_END

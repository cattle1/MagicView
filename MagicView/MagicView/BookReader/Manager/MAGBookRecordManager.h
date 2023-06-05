//
//  MAGBookRecordManager.h
//  MagicView
//
//  Created by LL on 2021/7/9.
//

#import <Foundation/Foundation.h>

#import "MAGBookModel.h"
#import "MAGBookReadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGBookRecordManager : NSObject

/// 小说阅读时长(秒)
@property (nonatomic, class, readonly) NSInteger readTime;

/// 小说阅读记录
@property (nonatomic, class, readonly) NSArray<MAGBookModel *> *readingRecord;

/// 小说收藏记录
@property (nonatomic, class, readonly) NSArray<MAGBookModel *> *collectionRecord;

/// 获取指定小说的阅读时长
+ (NSInteger)readTimeWithBookID:(NSString *)bookID;

/// 返回指定小说的已读状态
+ (BOOL)haveReadWithBookID:(NSString *)bookID;

/// 将指定小说添加到阅读记录中
+ (void)addReadRecordWithBookModel:(MAGBookModel *)bookModel;

/// 将指定小说从阅读记录中移除
+ (void)removeReadRecordWithBookID:(NSString *)bookID;

/// 返回指定小说的收藏状态
+ (BOOL)haveCollectWithBookID:(NSString *)bookID;

/// 将指定小说添加到收藏列表中
+ (void)addCollectWithBookModel:(MAGBookModel *)bookModel;

/// 将指定小说从收藏中移除
+ (void)removeCollectWithBookID:(NSString *)bookID;

/// 根据 bookID 从本地获取阅读记录，如果没有则创建一个空的阅读记录对象
+ (MAGBookReadModel *)readInfoWihthBookID:(NSString *)bookID;

@end

NS_ASSUME_NONNULL_END

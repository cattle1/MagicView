//
//  MAGBookReadModel.h
//  MagicView
//
//  Created by LL on 2021/9/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 小说的阅读记录
@interface MAGBookReadModel : NSObject

@property (nonatomic, copy, nullable) NSString *bookID;

@property (nonatomic, copy, nullable) NSString *chapterTitle;

@property (nonatomic, copy, nullable) NSString *chapterID;

/// 当前章节在目录中的索引位置
@property (nonatomic, assign) NSInteger chapterIndex;

/// 当前章节的总页数
@property (nonatomic, assign) NSInteger chapterPages;

/// 当前阅读的这一页内容
@property (nonatomic, copy, nullable) NSString *pageContent;

@property (nonatomic, assign) NSInteger pageIndex;

/// 阅读时长(秒)
@property (nonatomic, assign) NSInteger readTime;


+ (instancetype)bookReadWithBookID:(NSString *)bookID;

@end

NS_ASSUME_NONNULL_END

//
//  MAGBookChapterContentModel.h
//  MagicView
//
//  Created by LL on 2021/8/26.
//

#import <Foundation/Foundation.h>

@class MAGBookChapterContentBookModel;

NS_ASSUME_NONNULL_BEGIN

@interface MAGBookChapterContentModel : NSObject

@property (nonatomic, copy, nullable) NSString *content;

@property (nonatomic, copy, nullable) NSString *title;

@property (nonatomic, copy, nullable) NSString *chapterID;

/// 上一章的章节ID
@property (nonatomic, copy, nullable) NSString *previousChapterID;

/// 下一章的章节ID
@property (nonatomic, copy, nullable) NSString *nextChapterID;

@property (nonatomic, assign) NSInteger updateTime;

/// 当前章节在整个目录中的索引位置
@property (nonatomic, assign) NSInteger realIndex;

/// 本地可读状态
@property (nonatomic, assign, readonly) BOOL localCanRead;

@property (nonatomic, strong, nullable) MAGBookChapterContentBookModel *book;


+ (instancetype)emptyChapterContent;

@end


@interface MAGBookChapterContentBookModel : NSObject

@property (nonatomic, copy, nullable) NSString *bookID;

@property (nonatomic, copy, nullable) NSString *name;

@end

NS_ASSUME_NONNULL_END

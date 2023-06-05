//
//  MAGBookPageContentModel.h
//  MagicView
//
//  Created by LL on 2021/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 小说阅读器一页需要的所有内容
@interface MAGBookPageContentModel : NSObject

@property (nonatomic, copy, nullable) NSAttributedString *attributedString;

/// 原内容字符串
@property (nonatomic, copy, nullable) NSString *content;

@property (nonatomic, copy, nullable) NSString *bookID;

@property (nonatomic, copy, nullable) NSString *bookName;

@property (nonatomic, copy, nullable) NSString *chapterTitle;

@property (nonatomic, copy, nullable) NSString *chapterID;

@property (nonatomic, assign) NSInteger chapterIndex;

/// 章节总数量
@property (nonatomic, assign) NSInteger chapterCount;

/// 这一章的总页数
@property (nonatomic, assign) NSInteger chapterPages;

/// 当前这一页在这一章的索引位置
@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, assign, readonly) NSInteger localPrice;

@property (nonatomic, assign, readonly) BOOL localCanRead;

@end

NS_ASSUME_NONNULL_END

//
//  MAGBookCatalogModel.h
//  MagicView
//
//  Created by LL on 2021/8/24.
//

#import <Foundation/Foundation.h>

@class MAGBookCatalogListModel, MAGBookAuthorModel;

NS_ASSUME_NONNULL_BEGIN

@interface MAGBookCatalogModel : NSObject

/// 目录总数量(由于目录可能是分页的，所有list.count的数量不一定准确)
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, copy) NSString *bookName;

@property (nonatomic, copy) NSString *bookCover;

@property (nonatomic, copy) NSString *bookDescription;

@property (nonatomic, strong, nullable) MAGBookAuthorModel *author;

@property (nonatomic, copy, nullable) NSArray<MAGBookCatalogListModel *> *list;

@end


@interface MAGBookAuthorModel : NSObject

@property (nonatomic, copy, nullable) NSString *name;

@property (nonatomic, copy, nullable) NSString *note;

@property (nonatomic, copy, nullable) NSString *avatar;

@property (nonatomic, copy, nullable) NSString *authorID;

@end


@interface MAGBookCatalogListModel : NSObject

@property (nonatomic, copy, nullable) NSString *bookID;

@property (nonatomic, copy, nullable) NSString *chapterID;

@property (nonatomic, copy, nullable) NSString *chapterTitle;

@property (nonatomic, copy, nullable) NSString *previousChapterID;

@property (nonatomic, copy, nullable) NSString *nextChapterID;

/// 章节最后更新的时间
@property (nonatomic, assign) NSInteger updateTime;

/// 这一章在整个章节列表中的索引
@property (nonatomic, assign) NSInteger realIndex;

@property (nonatomic, assign) NSInteger chapterWords;

@end

NS_ASSUME_NONNULL_END

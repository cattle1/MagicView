//
//  MAGBookCatalogModel.m
//  MagicView
//
//  Created by LL on 2021/8/24.
//

#import "MAGBookCatalogModel.h"

@implementation MAGBookCatalogModel

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
        @"bookDescription" : @"description",
        @"list" : @"chapter_list",
        @"bookName" : @"name",
        @"bookCover" : @"cover",
        @"count" : @"total_chapter"
    };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"list" : MAGBookCatalogListModel.class,
        @"author" : MAGBookAuthorModel.class
    };
}

@end


@implementation MAGBookAuthorModel

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
        @"name" : @"author_name",
        @"note" : @"author_note",
        @"avatar" : @"author_avatar",
        @"authorID" : @"author_id"
    };
}

@end


@implementation MAGBookCatalogListModel

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
        @"chapterID" : @"chapter_id",
        @"updateTime" : @"update_time",
        @"chapterTitle" : @"chapter_title",
        @"realIndex" : @"display_order",
        @"previousChapterID" : @"last_chapter",
        @"nextChapterID" : @"next_chapter",
        @"bookID" : @"book_id",
        @"chapterWords" : @"words"
    };
}

@end

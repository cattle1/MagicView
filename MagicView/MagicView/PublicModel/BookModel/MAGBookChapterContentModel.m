//
//  MAGBookChapterContentModel.m
//  MagicView
//
//  Created by LL on 2021/8/26.
//

#import "MAGBookChapterContentModel.h"

#import "MAGImport.h"
#import "MAGPurchaseManager.h"

@implementation MAGBookChapterContentModel

+ (instancetype)emptyChapterContent {
    MAGBookChapterContentModel *contentModel = [[self alloc] init];
    contentModel.content = mBookNoDataIdentifier;
    return contentModel;
}

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
        @"title" : @"chapter_title",
        @"chapterID" : @"chapter_id",
        @"updateTime" : @"update_time",
        @"realIndex" : @"display_order",
        @"previousChapterID" : @"last_chapter",
        @"nextChapterID" : @"next_chapter",
    };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"book" : MAGBookChapterContentBookModel.class
    };
}

- (BOOL)localCanRead {
    if (!mLocalPaymentSwitch) return YES;
    if (MAGUserInfoManager.userInfo.isVIP) return YES;
    
    return [MAGPurchaseManager checkPurchaseStatusWithBookID:self.book.bookID chapterID:self.chapterID];
}

@end


@implementation MAGBookChapterContentBookModel

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
        @"bookID" : @"book_id"
    };
}

@end

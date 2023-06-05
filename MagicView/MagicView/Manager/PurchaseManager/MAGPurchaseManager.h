//
//  MAGPurchaseManager.h
//  MagicView
//
//  Created by LL on 2021/9/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 管理小说的购买状态
@interface MAGPurchaseManager : NSObject

/// 检查指定书籍指定章节的购买状态，如果已购买则返回YES，否则返回NO
+ (BOOL)checkPurchaseStatusWithBookID:(NSString *)bookID chapterID:(NSString *)chapterID;

/// 将指定书籍指定章节标记为已购买
+ (void)purchaseSuccessWithBookID:(NSString *)bookID chapterID:(NSString *)chapterID;

/// 小说章节已购买数量
+ (NSInteger)purchaseNumber;

@end

NS_ASSUME_NONNULL_END

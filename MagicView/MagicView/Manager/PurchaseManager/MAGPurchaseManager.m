//
//  MAGPurchaseManager.m
//  MagicView
//
//  Created by LL on 2021/9/16.
//

#import "MAGPurchaseManager.h"

#import "MAGImport.h"

@implementation MAGPurchaseManager

static NSMutableSet *_bookPurchaseSets;
+ (void)initialize {
    NSArray *purchaseArray = [NSArray m_arrayWithContentsOfFile:MAGFileManager.bookPurchaseFilePath];
    _bookPurchaseSets = [NSMutableSet setWithArray:purchaseArray];
    
    [mNotificationCenter addObserver:self selector:@selector(appWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
}

+ (BOOL)checkPurchaseStatusWithBookID:(NSString *)bookID chapterID:(NSString *)chapterID {
    if (mObjectIsEmpty(bookID) || mObjectIsEmpty(chapterID)) return NO;
    
    NSString *identifier = [NSString stringWithFormat:@"%@%@", bookID, chapterID].m_optionalEncryption;
    
    return [_bookPurchaseSets containsObject:identifier];
}

+ (void)purchaseSuccessWithBookID:(NSString *)bookID chapterID:(NSString *)chapterID {
    if (mObjectIsEmpty(bookID) || mObjectIsEmpty(chapterID)) return;
    
    NSString *identifier = [NSString stringWithFormat:@"%@%@", bookID, chapterID].m_optionalEncryption;
    
    [_bookPurchaseSets addObject:identifier];
}

+ (NSInteger)purchaseNumber {
    return _bookPurchaseSets.count;
}


#pragma mark - Notification
+ (void)appWillResignActiveNotification {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_bookPurchaseSets.allObjects m_writeToFile:MAGFileManager.bookPurchaseFilePath];
    });
}

@end

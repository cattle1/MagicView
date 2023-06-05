//
//  MAGBookPageContentModel.m
//  MagicView
//
//  Created by LL on 2021/9/15.
//

#import "MAGBookPageContentModel.h"

#import "MAGImport.h"
#import "MAGPurchaseManager.h"

@implementation MAGBookPageContentModel

- (NSInteger)localPrice {
    return mChapterPrice;
}

- (BOOL)localCanRead {
    if (!mLocalPaymentSwitch) return YES;
    if (MAGUserInfoManager.userInfo.isVIP) return YES;
    
    return [MAGPurchaseManager checkPurchaseStatusWithBookID:self.bookID chapterID:self.chapterID];
}

@end

//
//  MAGBookBuyView.m
//  MagicView
//
//  Created by LL on 2021/9/15.
//

#import "MAGBookBuyView.h"

#import "MAGBookBuyView1.h"
#import "MAGRechargeViewController.h"
#import "MAGPurchaseManager.h"
#import "MAGLoginViewController.h"

@implementation MAGBookBuyView

+ (instancetype)buyViewWithPageContent:(MAGBookPageContentModel * _Nullable)pageContent {
    MAGBookBuyView *buyView = [[MAGBookBuyView1 alloc] init];
    buyView.pageContent = pageContent;
    return buyView;
}

#pragma mark - 初始化
- (void)initialize {
    [super initialize];
    
    self.frame = MAGBookReaderManager.readerFrame;
    self.backgroundColor = mClearColor;
}


#pragma mark - UI
- (void)createSubviews {
    [super createSubviews];
    
    UIImageView *backgroundImageView = [MAGUIFactory imageView];
    self.backgroundImageView = backgroundImageView;
    backgroundImageView.frame = CGRectMake(0, CGRectGetHeight(self.frame) / 2.0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 2.0);
    backgroundImageView.image = MAGBookReaderManager.readerBackgroundImage;
    [self addSubview:backgroundImageView];
    
    [mNotificationCenter addObserver:self selector:@selector(backgroundImageDidChangeNotification) name:MAGBookReaderBackgroundImageDidChangeNotification object:nil];
}

- (void)buyChapterContent {
    if (!MAGUserInfoManager.isLogin) {
        [MAGLoginViewController presentLoginViewController:nil];
        return;
    }
    
    NSDictionary *clickAttributeds = @{@"book_id" : self.pageContent.bookID, @"chapter_index" : @(self.pageContent.chapterIndex)};
    
    if (MAGUserInfoManager.userInfo.remain < self.pageContent.localPrice) {
        [self.viewController.navigationController pushViewController:[MAGRechargeViewController rechargeViewController] animated:YES];
        [MAGClickAgent event:@"用户在小说阅读器跳转到充值页面" attributes:clickAttributeds];
    } else {
        MAGUserInfoManager.userInfo.remain -= self.pageContent.localPrice;
        [MAGUserInfoManager updateUserInfo:MAGUserInfoManager.userInfo];
        [MAGPurchaseManager purchaseSuccessWithBookID:self.pageContent.bookID chapterID:self.pageContent.chapterID];
        [mNotificationCenter postNotificationName:MAGBookReaderNeedRefreshNotification object:self.pageContent.bookID.deepCopy];
        [MAGClickAgent event:@"用户购买了小说本地章节" attributes:clickAttributeds];
    }
}


#pragma mark - Setter
- (void)setPageContent:(MAGBookPageContentModel *)pageContent {
    _pageContent = pageContent;
    
    if (_pageContent == nil) {
        self.hidden = YES;
        return;
    }
    
    self.hidden = pageContent.localCanRead;
}


#pragma mark - Notification
- (void)backgroundImageDidChangeNotification {
    self.backgroundImageView.image = MAGBookReaderManager.readerBackgroundImage;
}

@end

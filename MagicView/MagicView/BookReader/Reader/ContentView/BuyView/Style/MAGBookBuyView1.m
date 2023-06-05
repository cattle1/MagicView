//
//  MAGBookBuyView1.m
//  MagicView
//
//  Created by LL on 2021/9/16.
//

#import "MAGBookBuyView1.h"

@interface MAGBookBuyView1 ()

@property (nonatomic, weak) UIButton *buyButton;

@end

@implementation MAGBookBuyView1

- (void)initialize {
    [super initialize];
}

- (void)createSubviews {
    [super createSubviews];
    
    self.backgroundImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), mSafeAreaInsertBottom + 120);
    self.backgroundImageView.bottom = CGRectGetHeight(self.frame);
    
    UIButton *buyButton = [MAGUIFactory buttonWithTarget:self action:@selector(buyChapterContent)];
    self.buyButton = buyButton;
    buyButton.frame = CGRectMake(25.0, 0, 0, 45.0);
    buyButton.width = kScreenWidth - 2 * CGRectGetMinX(buyButton.frame);
    buyButton.centerY = CGRectGetHeight(self.backgroundImageView.frame) / 2.0;
    buyButton.layer.borderColor = MAGBookReaderManager.readerTextColor.CGColor;
    buyButton.layer.borderWidth = 0.75;
    [buyButton setTitleColor:MAGBookReaderManager.readerTextColor forState:UIControlStateNormal];
    buyButton.titleLabel.numberOfLines = 2;
    buyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundImageView addSubview:buyButton];
}

- (void)setPageContent:(MAGBookPageContentModel *)pageContent {
    [super setPageContent:pageContent];
    
    [self.buyButton setAttributedTitle:[self buyButtonTitle] forState:UIControlStateNormal];
}

- (NSAttributedString *)buyButtonTitle {    
    NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] init];
    NSString *title = [NSString stringWithFormat:@"%@ %zd %@\n", @"购买本章", self.pageContent.localPrice, @"书币"];
    NSString *desc = [NSString stringWithFormat:@"%@: %zd %@", @"我的余额", MAGUserInfoManager.userInfo.remain, @"书币"];
    [titleAttributedString appendString:title];
    [titleAttributedString appendString:desc];
    
    [titleAttributedString setAttribute:NSFontAttributeName value:mBoldFont15 range:NSMakeRange(0, title.length)];
    [titleAttributedString setAttribute:NSFontAttributeName value:mFont11 range:NSMakeRange(title.length, desc.length)];
    [titleAttributedString setColor:MAGBookReaderManager.readerTextColor];
    titleAttributedString.lineSpacing = mQuarterMargin;
    titleAttributedString.alignment = NSTextAlignmentCenter;
    
    return [titleAttributedString copy];
}


#pragma mark - Notification
- (void)backgroundImageDidChangeNotification {
    [super backgroundImageDidChangeNotification];
    
    self.buyButton.layer.borderColor = MAGBookReaderManager.readerTextColor.CGColor;
    [self.buyButton setTitleColor:MAGBookReaderManager.readerTextColor forState:UIControlStateNormal];
    [self.buyButton setAttributedTitle:[self buyButtonTitle] forState:UIControlStateNormal];
}

@end

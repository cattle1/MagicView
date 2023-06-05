//
//  MAGBookContentView1.m
//  MagicView
//
//  Created by LL on 2021/9/1.
//

#import "MAGBookContentView1.h"

@interface MAGBookContentView1 ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *progressLabel;

@end

@implementation MAGBookContentView1

- (void)createSubviews {
    [super createSubviews];
    
    UILabel *titleLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mFont12 textColor:MAGBookReaderManager.readerTextColor];
    self.titleLabel = titleLabel;
    titleLabel.text = self.pageContent.chapterTitle ?: @"";
    titleLabel.hidden = (self.pageContent.pageIndex == 0);
    titleLabel.frame = CGRectMake(mHalfMargin, mSafeAreaInsertTop, kScreenWidth - mMoreHalfMargin, 20.0);
    [_topView addSubview:titleLabel];
    
    UILabel *progressLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mFont14 textColor:MAGBookReaderManager.readerTextColor];
    self.progressLabel = progressLabel;
    progressLabel.text = [NSString stringWithFormat:@"%zd/%zd", (NSInteger)(self.pageContent.pageIndex + 1), self.pageContent.chapterPages];
    progressLabel.textAlignment = NSTextAlignmentRight;
    progressLabel.frame = CGRectMake(0, 20, kScreenWidth - mHalfMargin, 20.0);
    [_bottomView addSubview:progressLabel];
}

- (void)setPageContent:(MAGBookPageContentModel *)pageContent {
    [super setPageContent:pageContent];
    
    self.titleLabel.text = pageContent.chapterTitle;
    self.progressLabel.text = [NSString stringWithFormat:@"%zd/%zd", (NSInteger)(pageContent.pageIndex + 1), pageContent.chapterPages];
    
    self.titleLabel.hidden = (pageContent.pageIndex == 0);
}


#pragma mark - Notification
- (void)backgroundImageDidChangeNotification {
    [super backgroundImageDidChangeNotification];
    
    self.titleLabel.textColor = MAGBookReaderManager.readerTextColor;
    self.progressLabel.textColor = MAGBookReaderManager.readerTextColor;
}

@end

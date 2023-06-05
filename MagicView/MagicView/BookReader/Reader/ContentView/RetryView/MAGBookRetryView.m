//
//  MAGBookRetryView.m
//  MagicView
//
//  Created by LL on 2021/9/17.
//

#import "MAGBookRetryView.h"

#import "MAGBookPageContentModel.h"

@implementation MAGBookRetryView

- (void)initialize {
    [super initialize];
    
    self.backgroundColor = mClearColor;
}

- (void)createSubviews {
    [super createSubviews];
    
    UIView *contentView = [MAGUIFactory view];
    [self addSubview:contentView];
    
    UILabel *titleLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mBoldFont16 textColor:MAGBookReaderManager.readerTextColor];
    titleLabel.text = @"加载失败";
    [contentView addSubview:titleLabel];
    
    UIButton *retryButton = [MAGUIFactory buttonWithType:UIButtonTypeSystem backgroundColor:nil font:mFont13 textColor:mBookReaderHighlightColor target:self action:@selector(refreshBookReader)];
    [retryButton setTitle:@"重试" forState:UIControlStateNormal];
    [contentView addSubview:retryButton];
    
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.width.equalTo(self);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(contentView);
        make.size.mas_equalTo(titleLabel.m_textSize);
    }];
    
    [retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(mQuarterMargin);
        make.centerX.equalTo(contentView);
        make.size.mas_equalTo(retryButton.m_textSize);
        make.bottom.equalTo(contentView).priorityLow();
    }];
}

- (void)refreshBookReader {
    [mNotificationCenter postNotificationName:MAGBookReaderNeedRefreshNotification object:self.pageContent.bookID.deepCopy];
    [MAGClickAgent event:@"用户点击了小说重试按钮" attributes:@{@"book_id" : self.pageContent.bookID ?: @"NULL", @"chapter_index" : @(self.pageContent.chapterIndex)}];
}

@end

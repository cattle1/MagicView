//
//  MAGReadingRecordTableViewCell.m
//  MagicView
//
//  Created by LL on 2021/10/21.
//

#import "MAGReadingRecordTableViewCell.h"

#import "MAGBookModel.h"

@interface MAGReadingRecordTableViewCell ()

@property (nonatomic, weak) UIImageView *coverImageView;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *authorLabel;

@end

@implementation MAGReadingRecordTableViewCell

- (void)createSubviews {
    [super createSubviews];
    
    self.lineView.hidden = YES;
    
    UIImageView *coverImageView = [MAGUIFactory imageView];
    self.coverImageView = coverImageView;
    [self.contentView addSubview:coverImageView];
    
    UILabel *titleLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mBoldFont16 textColor:mTextColor1];
    self.titleLabel = titleLabel;
    titleLabel.numberOfLines = 2;
    titleLabel.m_maxLayoutWidthEqualWidth = YES;
    [self.contentView addSubview:titleLabel];
    
    UILabel *authorLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mFont13 textColor:mTextColor2];
    self.authorLabel = authorLabel;
    [self.contentView addSubview:authorLabel];
    
    
    [coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).inset(mHalfMargin);
        make.left.equalTo(self.contentView).offset(mMoreHalfMargin);
        make.width.mas_equalTo(65.0);
        make.height.equalTo(coverImageView.mas_width).multipliedBy(4.0 / 3.0);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(coverImageView.mas_centerY);
        make.left.equalTo(coverImageView.mas_right).offset(mMoreHalfMargin);
        make.right.equalTo(self.contentView).offset(-mMoreHalfMargin);
        make.height.mas_equalTo(0.0);
    }];
    
    [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(mQuarterMargin);
        make.left.right.equalTo(titleLabel);
        make.height.mas_equalTo([authorLabel.font m_textHeight]);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.1);
        make.top.equalTo(coverImageView.mas_bottom).offset(mHalfMargin).priorityLow();
    }];
}

- (void)setBookModel:(MAGBookModel *)bookModel {
    _bookModel = bookModel;
    
    [self.coverImageView setImageWithURL:bookModel.cover.m_URL placeholder:mPlaceholdImage];
    
    self.titleLabel.text = bookModel.name ?: @"";
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.titleLabel.m_textHeight);
    }];
    
    self.authorLabel.text = bookModel.author ?: @"";
}

@end

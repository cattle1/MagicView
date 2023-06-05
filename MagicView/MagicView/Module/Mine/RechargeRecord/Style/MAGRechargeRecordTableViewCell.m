//
//  MAGRechargeRecordTableViewCell.m
//  MagicView
//
//  Created by LL on 2021/10/20.
//

#import "MAGRechargeRecordTableViewCell.h"

#import "MAGRechargeRecordModel.h"

@interface MAGRechargeRecordTableViewCell ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *dateLabel;

@property (nonatomic, weak) UILabel *priceLabel;

@end

@implementation MAGRechargeRecordTableViewCell

- (void)createSubviews {
    [super createSubviews];
    
    UILabel *titleLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mFont18 textColor:mTextColor1];
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    UILabel *dateLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mFont14 textColor:mTextColor2];
    self.dateLabel = dateLabel;
    [self.contentView addSubview:dateLabel];
    
    UILabel *priceLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mBoldFont19 textColor:mHighlightColor1];
    self.priceLabel = priceLabel;
    [self.contentView addSubview:priceLabel];
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(mMoreHalfMargin);
        make.left.equalTo(self.contentView).offset(mMargin);
        make.right.equalTo(priceLabel.mas_left).offset(-mHalfMargin);
        make.height.mas_equalTo([titleLabel.font m_textHeight]);
    }];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(mQuarterMargin);
        make.left.right.equalTo(titleLabel);
        make.height.mas_equalTo([dateLabel.font m_textHeight]);
    }];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-mMargin);
        make.height.mas_equalTo([priceLabel.font m_textHeight]);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(0.0);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.right.equalTo(priceLabel);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(mLineHeight);
        make.top.equalTo(dateLabel.mas_bottom).offset(mMoreHalfMargin).priorityLow();
    }];
}

- (void)setRecordModel:(MAGRechargeRecordModel *)recordModel {
    _recordModel = recordModel;
    
    self.titleLabel.text = recordModel.title ?: @"";
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:recordModel.transactionDate];
    self.dateLabel.text = [date stringWithFormat:@"yyyy-MM-dd"];
    
    self.priceLabel.text = recordModel.fatPrice ?: @"";
    [self.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.priceLabel.m_textWidth);
    }];
}

@end

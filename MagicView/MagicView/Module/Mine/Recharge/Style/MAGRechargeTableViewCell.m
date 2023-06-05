//
//  MAGRechargeTableViewCell.m
//  MagicView
//
//  Created by LL on 2021/10/19.
//

#import "MAGRechargeTableViewCell.h"

#import "MAGRechargeModel.h"

@interface MAGRechargeTableViewCell ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *priceLabel;

@end

@implementation MAGRechargeTableViewCell

- (void)createSubviews {
    [super createSubviews];
    
    UILabel *titleLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mFont15 textColor:mTextColor1];
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    UILabel *priceLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mBoldFont16 textColor:mHighlightColor1];
    self.priceLabel = priceLabel;
    [self.contentView addSubview:priceLabel];
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(mMargin);
        make.top.height.equalTo(self.contentView);
        make.right.equalTo(priceLabel.mas_left).offset(-mHalfMargin);
    }];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-mMargin);
        make.top.height.equalTo(self.contentView);
        make.width.mas_equalTo(0.0);
    }];
    
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(mMargin);
    }];
}

- (void)setItemModel:(MAGRechargeItemModel *)itemModel {
    _itemModel = itemModel;
    
    self.titleLabel.text = itemModel.title ?: @"";
    
    self.priceLabel.text = itemModel.fatPrice ?: @"";
    [self.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.priceLabel.m_textWidth);
    }];
}

@end

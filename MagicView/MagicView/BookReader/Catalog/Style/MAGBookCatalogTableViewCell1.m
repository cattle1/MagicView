//
//  MAGBookCatalogTableViewCell.m
//  MagicView
//
//  Created by LL on 2021/8/31.
//

#import "MAGBookCatalogTableViewCell1.h"

#import "MAGBookCatalogModel.h"

@interface MAGBookCatalogTableViewCell1 ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIView *selectedView;

@end

@implementation MAGBookCatalogTableViewCell1

- (void)createSubviews {
    [super createSubviews];
    
    UILabel *titleLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mFont15 textColor:mTextColor1];
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    UIView *selectedView = [MAGUIFactory viewWithBackgroundColor:mHighlightColor1 cornerRadius:6.5];
    self.selectedView = selectedView;
    [self.contentView addSubview:selectedView];
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(mMoreHalfMargin);
        make.right.equalTo(selectedView.mas_left).offset(-mHalfMargin);
        make.centerY.height.equalTo(self.contentView);
    }];
    
    [selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-mMoreHalfMargin);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(selectedView.layer.cornerRadius * 2.0);
    }];
    
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(mMoreHalfMargin);
    }];
}

- (void)setCatalogModel:(MAGBookCatalogListModel *)catalogModel {
    _catalogModel = catalogModel;
    
    self.titleLabel.text = catalogModel.chapterTitle;
}

- (void)setChoose:(BOOL)choose {
    _choose = choose;
    
    self.selectedView.hidden = !_choose;
    self.titleLabel.textColor = _choose ? mHighlightColor1 : mTextColor1;
}

@end

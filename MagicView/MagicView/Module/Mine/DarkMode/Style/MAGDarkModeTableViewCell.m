//
//  MAGDarkModeTableViewCell.m
//  MagicView
//
//  Created by LL on 2021/10/22.
//

#import "MAGDarkModeTableViewCell.h"

@interface MAGDarkModeTableViewCell ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIView *selectedView;

@end

@implementation MAGDarkModeTableViewCell

- (void)initialize {
    [super initialize];
    
    self.contentView.backgroundColor = mBackgroundColor1;
}

- (void)createSubviews {
    [super createSubviews];
    
    UILabel *titleLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mFont16 textColor:mTextColor1];
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    UIView *selectedView = [MAGUIFactory viewWithBackgroundColor:mHighlightColor1 cornerRadius:6.5];
    self.selectedView = selectedView;
    [self.contentView addSubview:selectedView];
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(mMoreHalfMargin);
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

- (void)setStyle:(LLUserInterfaceStyle)style {
    _style = style;
    
    self.selectedView.hidden = (style != LLDarkManager.userInterfaceStyle);
    
    switch (_style) {
        case LLUserInterfaceStyleUnspecified: {
            self.titleLabel.text = @"跟随系统";
        }
            break;
        case LLUserInterfaceStyleLight: {
            self.titleLabel.text = @"浅色模式";
        }
            break;
        case LLUserInterfaceStyleDark: {
            self.titleLabel.text = @"深色模式";
        }
            break;
    }
}

@end

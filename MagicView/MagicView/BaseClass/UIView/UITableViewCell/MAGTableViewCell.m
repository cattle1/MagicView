//
//  MAGTableViewCell.m
//  MagicView
//
//  Created by LL on 2021/7/9.
//

#import "MAGTableViewCell.h"

@implementation MAGTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self defaultInitialize];
        [self initialize];
        [self createSubviews];
    }
    return self;
}

- (void)defaultInitialize {
    self.backgroundColor = mClearColor;
    self.contentView.backgroundColor = mClearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)initialize {}

- (void)createSubviews {
    UIView *lineView = [MAGUIFactory viewWithBackgroundColor:mLineColor cornerRadius:0.0];
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
    
    UIView *mainView = [MAGUIFactory view];
    self.mainView = mainView;
    [self.contentView addSubview:mainView];
    
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(mLineHeight);
    }];
}

- (void)setHiddenLine:(BOOL)hiddenLine {
    _hiddenLine = hiddenLine;
    
    self.lineView.hidden = hiddenLine;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    !self.m_frameBlock ?: self.m_frameBlock(self);
}

@end

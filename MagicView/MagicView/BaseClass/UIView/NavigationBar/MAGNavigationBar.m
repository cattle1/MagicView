//
//  MagicNavigationBar.m
//  MagicView
//
//  Created by LL on 2021/7/6.
//

#import "MAGNavigationBar.h"

@implementation MAGNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self mp_initialize];
        [self mp_createSubviews];
    }
    return self;
}

- (void)mp_initialize {
    _titleAutoCenter = YES;
}

- (void)mp_createSubviews {
    UIView *backgroundView = [MAGUIFactory view];
    _backgroundView = backgroundView;
    backgroundView.frame = CGRectMake(0, mSafeAreaInsertTop, kScreenWidth, mNavBarSafeAreaHeight);
    [self addSubview:backgroundView];
    
    UIImageView *backImageView = [MAGUIFactory imageView];
    backImageView.image = mBackwardImage.m_renderingModeAlwaysTemplate;
    _backImageView = backImageView;
    [backImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popViewController)]];
    backImageView.tintColor = mNavBarTintColor;
    backImageView.frame = CGRectMake(mMoreHalfMargin, 0, mMoreHalfMargin, mMoreHalfMargin);
    backImageView.centerY = CGRectGetHeight(backgroundView.frame) / 2.0;
    [backgroundView addSubview:backImageView];
    
    MAGLabel *titleLabel = (MAGLabel *)[MAGUIFactory labelWithBackgroundColor:nil font:mFont16 textColor:mNavBarTintColor];
    _titleLabel = titleLabel;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(mHalfMargin, 0, kScreenWidth - (2 * mHalfMargin), mNavBarSafeAreaHeight);
    [backgroundView addSubview:titleLabel];
    
    UIView *bottomLineView = [MAGUIFactory viewWithBackgroundColor:mLineColor cornerRadius:0.0];
    _bottomLineView = bottomLineView;
    bottomLineView.frame = CGRectMake(0, CGRectGetHeight(backgroundView.frame) - mLineHeight, kScreenWidth, mLineHeight);
    [backgroundView addSubview:bottomLineView];
    
    
    [backImageView addObserverBlockForKeyPath:mKEYPATH(backImageView, hidden) block:^(UIImageView *_Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
        if ([newVal boolValue]) {
            titleLabel.left = mHalfMargin;
        } else {
            titleLabel.left = CGRectGetMaxX(obj.frame) + mHalfMargin;
        }
        titleLabel.width = kScreenWidth - titleLabel.left - mHalfMargin;
    }];
}

- (void)popViewController {
    [self.viewController m_popViewController];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.isTitleAutoCenter && !self.backImageView.isHidden) {
        // 屏幕的中心点
        CGFloat screenCenterX = kScreenWidth / 2.0;
        
        // titleLabel的中心点
        CGFloat titleLabelCenterX = self.titleLabel.centerX;
        
        if (titleLabelCenterX == screenCenterX) return;
        
        CGFloat leftEdgeInset = titleLabelCenterX - screenCenterX;
        
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, -leftEdgeInset * 2, 0, 0);
        CGFloat textWidth = self.titleLabel.m_textWidth;
        CGFloat textLeft = (CGRectGetWidth(self.titleLabel.frame) - textWidth) / 2.0;
        CGFloat newTextLeft = textLeft + edgeInsets.left;
        
        // 如果文本偏移后显示范围已经超出了Label左侧区域，则取消偏移
        if (newTextLeft < 0) return;
        
        self.titleLabel.m_edgeInsets = edgeInsets;
    }
}

@end

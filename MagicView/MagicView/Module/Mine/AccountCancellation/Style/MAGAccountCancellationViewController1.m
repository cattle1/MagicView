//
//  MAGAccountCancellationViewController1.m
//  MagicView
//
//  Created by LL on 2022/1/24.
//

#import "MAGAccountCancellationViewController1.h"

@interface MAGAccountCancellationViewController1 ()

@property (nonatomic, weak) UIScrollView *mainScrollView;

@end

@implementation MAGAccountCancellationViewController1

- (void)initialize {
    [super initialize];
    
    [mNotificationCenter addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [mNotificationCenter addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)createSubviews {
    [super createSubviews];
    
    UIScrollView *mainScrollView = [MAGUIFactory scrollView];
    self.mainScrollView = mainScrollView;
    mainScrollView.showsVerticalScrollIndicator = YES;
    if (mSafeAreaInsertBottom > 0) {
        mainScrollView.contentInset = UIEdgeInsetsMake(0, 0, mSafeAreaInsertBottom, 0);
    } else {
        mainScrollView.contentInset = UIEdgeInsetsMake(0, 0, mMargin, 0);
    }
    [self.view addSubview:mainScrollView];
    
    UIView *contentView = [MAGUIFactory view];
    [contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [mMainWindow endEditing:YES];
    }]];
    [mainScrollView addSubview:contentView];
    
    UILabel *rulesLabel = [MAGUIFactory label];
    rulesLabel.numberOfLines = 0;
    rulesLabel.preferredMaxLayoutWidth = kScreenWidth - 2 * mMoreHalfMargin;
    {
        NSString *ruleTitle = @"温馨提示";
        NSMutableString *ruleString = [NSMutableString stringWithFormat:@"%@\n", ruleTitle];
        [self.ruleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [ruleString appendFormat:@"%zd. %@\n", idx + 1, obj];
        }];
        
        NSMutableAttributedString *rulesAttributedString = [[NSMutableAttributedString alloc] initWithString:ruleString attributes:@{NSFontAttributeName : mFont14, NSForegroundColorAttributeName : mTextColor2}];
        [rulesAttributedString setAttributes:@{NSFontAttributeName : mFont15, NSForegroundColorAttributeName : mTextColor1} range:ruleTitle.rangeOfAll];
        rulesAttributedString.lineSpacing = mQuarterMargin;
        rulesLabel.attributedText = [rulesAttributedString copy];
    }
    [contentView addSubview:rulesLabel];
    
    UIView *lineView = [MAGUIFactory viewWithBackgroundColor:mLineColor cornerRadius:0.0];
    [contentView addSubview:lineView];
    
    UILabel *reasonLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mFont16 textColor:mTextColor1];
    reasonLabel.text = [NSString stringWithFormat:@"%@(%@):", @"请告诉我们您注销账号的原因", @"可选"];
    reasonLabel.numberOfLines = 0;
    reasonLabel.preferredMaxLayoutWidth = rulesLabel.preferredMaxLayoutWidth;
    [contentView addSubview:reasonLabel];
    
    UITextView *reasonTextView = [MAGUIFactory textViewWithBackgroundColor:mBackgroundColor2 delegate:nil textColor:mTextColor1 font:mFont14 editable:YES];
    reasonTextView.textContainerInset = UIEdgeInsetsMake(mHalfMargin, mQuarterMargin, mHalfMargin, mQuarterMargin);
    reasonTextView.layer.cornerRadius = 5.0;
    reasonTextView.m_placeholderText = [NSString stringWithFormat:@"%@。", @"您的意见和反馈对我们非常重要，有利于我们改善服务。如果您有任何意见或建议，请您在此填写"];
    [contentView addSubview:reasonTextView];
    
    UIButton *sureButton = [MAGUIFactory buttonWithType:UIButtonTypeSystem backgroundColor:mHighlightColor1 font:mBoldFont15 textColor:UIColor.whiteColor target:self action:@selector(accountCancellationEvent)];
    [sureButton setTitle:@"确认注销" forState:UIControlStateNormal];
    sureButton.layer.cornerRadius = 4.0;
    [contentView addSubview:sureButton];
    
    
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.width.equalTo(mainScrollView);
    }];
    
    [rulesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(mMoreHalfMargin);
        make.width.mas_equalTo(rulesLabel.preferredMaxLayoutWidth);
        make.centerX.equalTo(contentView);
        make.height.mas_equalTo(rulesLabel.m_textHeight);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rulesLabel.mas_bottom);
        make.left.right.equalTo(contentView);
        make.height.mas_equalTo(mHalfMargin);
    }];
    
    [reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(mMargin);
        make.centerX.equalTo(contentView);
        make.width.mas_equalTo(reasonLabel.preferredMaxLayoutWidth);
        make.height.mas_equalTo(reasonLabel.m_textHeight);
    }];
    
    [reasonTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(reasonLabel.mas_bottom).offset(mMoreHalfMargin);
        make.centerX.equalTo(contentView);
        make.width.equalTo(reasonLabel);
        make.height.mas_equalTo(145.0);
    }];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(reasonTextView.mas_bottom).offset(mMargin);
        make.centerX.equalTo(contentView);
        make.width.equalTo(reasonTextView);
        make.height.mas_equalTo(40.0);
        make.bottom.equalTo(contentView);
    }];
}


#pragma mark - Notification
- (void)keyboardWillShowNotification:(NSNotification *)noti {
    NSDictionary *keyboardInfo = noti.userInfo;
    
    CGFloat keyboardHeight = ({
        CGRect keyboardFrame = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRectGetHeight(keyboardFrame);
    });
    
    double animationDuration = [keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.mainScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-keyboardHeight);
        }];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.mainScrollView scrollToBottom];
        }
    }];
    
    [self.view layoutIfNeeded];
}

- (void)keyboardWillHideNotification:(NSNotification *)noti {
    NSDictionary *keyboardInfo = noti.userInfo;
    
    double animationDuration = [keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.mainScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.mainScrollView scrollToTop];
        }
    }];
    
    [self.view layoutIfNeeded];
}

@end
 

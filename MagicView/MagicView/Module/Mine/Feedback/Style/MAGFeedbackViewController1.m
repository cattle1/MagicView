//
//  MAGFeedbackViewController1.m
//  MagicView
//
//  Created by LL on 2021/10/20.
//

#import "MAGFeedbackViewController1.h"

@interface MAGFeedbackViewController1 ()<YYTextViewDelegate, UITextFieldDelegate>

@property (nonatomic, assign) NSInteger maxNumber;


@property (nonatomic, weak) UILabel *textNumberLabel;

@property (nonatomic, weak) UIButton *submitButton;

@property (nonatomic, weak) YYTextView *textView;

@property (nonatomic, weak) UITextField *connectTextField;

@end

@implementation MAGFeedbackViewController1

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setStatusBarLightStyle];
}

- (void)initialize {
    [super initialize];
    
    [self setNavigationBarTitle:@"帮助反馈"];
    self.maxNumber = 200;
    self.view.backgroundColor = mBackgroundColor2;
    mWeakobj(self)
    [self.navigationBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer * _Nonnull sender) {
        [weak_self.view endEditing:YES];
    }]];
}

- (void)createSubviews {
    [super createSubviews];
    
    UIScrollView *scrollView = [MAGUIFactory scrollView];
    [self.view addSubview:scrollView];
    
    UIView *contentView = [MAGUIFactory viewWithBackgroundColor:mBackgroundColor1 cornerRadius:0.0];
    [scrollView addSubview:contentView];
    
    UIView *placeholderView = [MAGUIFactory view];
    mWeakobj(self)
    [placeholderView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer * _Nonnull sender) {
        [weak_self.view endEditing:YES];
    }]];
    [self.view addSubview:placeholderView];
    
    UIButton *submitButton = [MAGUIFactory buttonWithType:UIButtonTypeSystem backgroundColor:nil font:mFont16 textColor:UIColor.whiteColor target:self action:@selector(submitEvent)];
    self.submitButton = submitButton;
    [submitButton setTitle:@"提交反馈" forState:UIControlStateNormal];
    submitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    submitButton.layer.cornerRadius = 45.0 / 2.0;
    [submitButton addObserverBlockForKeyPath:mKEYPATH(submitButton, enabled) block:^(UIButton * _Nonnull submitButton, id  _Nullable oldVal, id  _Nullable newVal) {
        if ([newVal boolValue]) {
            submitButton.backgroundColor = mHighlightColor1;
        } else {
            submitButton.backgroundColor = mGrayColor;
        }
    }];
    submitButton.enabled = NO;
    [self.view addSubview:submitButton];
    
    YYTextView *textView = [MAGUIFactory yyTextView];
    self.textView = textView;
    textView.delegate = self;
    textView.placeholderFont = textView.font;
    textView.placeholderTextColor = mPlaceholderColor;
    textView.textColor = mTextColor1;
    textView.placeholderText = @"为更好的解决您遇到的问题，请尽量将问题描述详细";
    [contentView addSubview:textView];
    
    UILabel *textNumberLabel = [MAGUIFactory labelWithBackgroundColor:contentView.backgroundColor font:mFont15 textColor:mPlaceholderColor];
    self.textNumberLabel = textNumberLabel;
    textNumberLabel.textAlignment = NSTextAlignmentRight;
    textNumberLabel.text = [NSString stringWithFormat:@"0/%zd", self.maxNumber];
    [contentView addSubview:textNumberLabel];
    
    UIView *lineView1 = [MAGUIFactory viewWithBackgroundColor:mLineColor cornerRadius:0.0];
    [contentView addSubview:lineView1];
    
    UILabel *connectLabel = [MAGUIFactory labelWithBackgroundColor:nil font:textView.font textColor:mTextColor1];
    connectLabel.text = @"联系方式(手机号/邮箱地址)";
    connectLabel.numberOfLines = 0;
    connectLabel.preferredMaxLayoutWidth = kScreenWidth - 2 * mMoreHalfMargin;
    [contentView addSubview:connectLabel];
    
    UIView *lineView2 = [MAGUIFactory viewWithBackgroundColor:mLineColor cornerRadius:0.0];
    [contentView addSubview:lineView2];
    
    UITextField *connectTextField = [MAGUIFactory textFieldWithBackgroundColor:nil placeholder:@"您的联系方式" textColor:mTextColor1 font:textView.font delegate:self isNumber:NO];
    self.connectTextField = connectTextField;
    connectTextField.returnKeyType = UIReturnKeyDone;
    [connectTextField addTarget:self action:@selector(connectDidChange) forControlEvents:UIControlEventEditingChanged];
    [contentView addSubview:connectTextField];
    
    UIView *bottomView = [MAGUIFactory view];
    [contentView addSubview:bottomView];
    
    
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (mSafeAreaInsertBottom > 0) {
            make.bottom.equalTo(self.view).offset(-mSafeAreaInsertBottom);
        } else {
            make.bottom.equalTo(self.view).offset(-mMargin);
        }
        make.left.right.equalTo(self.view).inset(35.0);
        make.height.mas_equalTo(submitButton.layer.cornerRadius * 2.0);
    }];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(submitButton.mas_top).offset(-mHalfMargin);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.width.equalTo(scrollView);
    }];
    
    [placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(contentView).inset(mMoreHalfMargin);
        make.height.mas_equalTo(kScreenWidth * 0.45);
    }];
    
    [textNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-mMoreHalfMargin);
        make.height.mas_equalTo([textNumberLabel.font m_textHeight] + mMargin);
        make.left.equalTo(contentView);
        make.top.equalTo(textView.mas_bottom);
    }];
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(textNumberLabel.mas_bottom);
        make.height.mas_equalTo(1.0);
    }];
    
    [connectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView1.mas_bottom);
        make.left.equalTo(contentView).offset(mMoreHalfMargin);
        make.width.mas_equalTo(connectLabel.preferredMaxLayoutWidth);
        make.height.mas_equalTo(45.0);
    }];
    
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(connectLabel);
        make.left.right.equalTo(contentView);
        make.height.equalTo(lineView1);
    }];
    
    [connectTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(connectLabel.mas_bottom);
        make.left.right.equalTo(contentView).inset(mMoreHalfMargin);
        make.height.mas_equalTo(45.0);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(contentView);
        make.height.mas_equalTo(0.1);
        make.top.equalTo(connectTextField.mas_bottom).priorityLow();
    }];
}

- (void)submitEvent {
    MAGProgressHUD *hud = [mMainWindow m_showDarkHUDFromText:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(mRandomFloat(1.0, 2.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
        [mMainWindow m_showSuccessHUDFromText:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    });
    [MAGClickAgent event:@"用户提交了反馈" attributes:@{@"content" : self.textView.text, @"connect" : self.connectTextField.text}];
}

- (void)connectDidChange {
    self.submitButton.enabled = (self.textView.text.length > 0) && (self.connectTextField.text.length > 0);
}


#pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {
    if (textView.text.length > self.maxNumber) {
        textView.text = [textView.text substringToIndex:self.maxNumber];
    }
    self.textNumberLabel.text = [NSString stringWithFormat:@"%zd/%zd", textView.text.length, self.maxNumber];
    
    self.submitButton.enabled = (self.textView.text.length > 0) && (self.connectTextField.text.length > 0);
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.submitButton.enabled) {
        [self submitEvent];
    }
    return YES;
}

@end

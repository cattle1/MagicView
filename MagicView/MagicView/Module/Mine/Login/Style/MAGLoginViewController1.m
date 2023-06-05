//
//  MAGLoginViewController1.m
//  MagicView
//
//  Created by LL on 2021/10/16.
//

#import "MAGLoginViewController1.h"

#import "MAGResourceLinkManager.h"

typedef NS_ENUM(NSInteger, MAGLoginButtonStyle) {
    MAGLoginButtonStyleWechat   = 2,
    MAGLoginButtonStyleQQ       = 3,
    MAGLoginButtonStyleTourist  = 4,
};

@implementation MAGLoginViewController1

- (void)initialize {
    [super initialize];
    
    self.view.backgroundColor = mBackgroundColor1;
    [self setNavigationBarHidden:YES];
}

- (void)createSubviews {
    [super createSubviews];
    
    UIScrollView *scrollView = [MAGUIFactory scrollView];
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer * _Nonnull sender) {
        UIView *view = sender.view;
        [view endEditing:YES];
    }]];
    [self.view addSubview:scrollView];
    
    UIView *contentView = [MAGUIFactory view];
    [scrollView addSubview:contentView];
    
    YYLabel *protocolLabel = [MAGUIFactory yyLabel];
    protocolLabel.numberOfLines = 0;
    protocolLabel.preferredMaxLayoutWidth = kScreenWidth - 2 * mMargin;
    NSString *userProtocol = @"用户协议";
    NSString *privateProtocol = @"隐私政策";
    NSString *protocolString = [NSString stringWithFormat:@"登录即表示您同意%@和%@", [NSString stringWithFormat:@"《%@》", userProtocol], [NSString stringWithFormat:@"《%@》", privateProtocol]];
    NSMutableAttributedString *protocolAttr = [[NSMutableAttributedString alloc] initWithString:protocolString];
    protocolAttr.alignment = NSTextAlignmentCenter;
    [protocolAttr setAttribute:NSFontAttributeName value:mFont14];
    [protocolAttr setAttribute:NSForegroundColorAttributeName value:mTextColor2];
    
    [protocolAttr setTextHighlightRange:[protocolString rangeOfString:userProtocol] color:mHighlightColor1 backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [UIApplication.sharedApplication openURL:mUserProtocolLink.m_URL options:@{} completionHandler:nil];
        [MAGClickAgent event:@"用户点击了登录页面的用户协议" attributes:@{@"url" : mUserProtocolLink}];
    }];
    
    [protocolAttr setTextHighlightRange:[protocolString rangeOfString:privateProtocol] color:mHighlightColor1 backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [UIApplication.sharedApplication openURL:mPrivacyProtocolLink.m_URL options:@{} completionHandler:nil];
        [MAGClickAgent event:@"用户点击了登录页面的隐私协议" attributes:@{@"url" : mUserProtocolLink}];
    }];
    
    protocolLabel.attributedText = protocolAttr;
    [self.view addSubview:protocolLabel];
    
    UIButton *closeButton = [MAGUIFactory buttonWithTarget:self action:@selector(m_popViewController)];
    [closeButton setImage:mCloseImage.m_renderingModeAlwaysTemplate forState:UIControlStateNormal];
    closeButton.tintColor = mBlackColor;
    [self.view addSubview:closeButton];
    
    UILabel *titleLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mFont26 textColor:mTextColor2];
    titleLabel.text = @"登录中心";
    [contentView addSubview:titleLabel];
    
    self.accountTextField.placeholder = @"请输入您的账号";
    [self.accountTextField m_addBorderLineWithStyle:MBorderLineStyleBottom borderColor:mLineColor borderWidth:mLineHeight];
    [contentView addSubview:self.accountTextField];
    
    self.passwordTextField.placeholder = @"请输入您的密码";
    [self.passwordTextField m_addBorderLineWithStyle:MBorderLineStyleBottom borderColor:mLineColor borderWidth:mLineHeight];
    [contentView addSubview:self.passwordTextField];
    
    self.loginButton.layer.cornerRadius = 4.5;
    [self.loginButton setTitle:@"注册并登录" forState:UIControlStateNormal];
    [contentView addSubview:self.loginButton];
    
    UIView *lineView = [MAGUIFactory viewWithBackgroundColor:mLineColor cornerRadius:0.0];
    [contentView addSubview:lineView];
    
    UILabel *otherLabel = [MAGUIFactory labelWithBackgroundColor:self.view.backgroundColor font:mFont13 textColor:mTextColor1];
    otherLabel.text = @"其他登录方式";
    otherLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:otherLabel];
    
    if (@available(iOS 13.0, *)) {
        [contentView addSubview:self.appleButton];
    }
    
    UIView *thirdLoginView = [MAGUIFactory view];
    [contentView addSubview:thirdLoginView];
    
    NSMutableArray<UIButton *> *buttonArray = [NSMutableArray array];
    
    UIButton *touristButton = [self createThirdButtonWithStyle:MAGLoginButtonStyleTourist];
    touristButton.layer.cornerRadius = self.loginButton.layer.cornerRadius;
    [thirdLoginView addSubview:touristButton];
    [buttonArray addObject:touristButton];
    
    if (mWechatLoginSwitch) {
        UIButton *wechatButton = [self createThirdButtonWithStyle:MAGLoginButtonStyleWechat];
        wechatButton.layer.cornerRadius = self.loginButton.layer.cornerRadius;
        [thirdLoginView addSubview:wechatButton];
        [buttonArray addObject:wechatButton];
    }
    
    if (mQQLoginSwitch) {
        UIButton *qqButton = [self createThirdButtonWithStyle:MAGLoginButtonStyleQQ];
        qqButton.layer.cornerRadius = self.loginButton.layer.cornerRadius;
        [thirdLoginView addSubview:qqButton];
        [buttonArray addObject:qqButton];
    }
    
    UIView *bottomView = [MAGUIFactory view];
    [contentView addSubview:bottomView];
    
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(protocolLabel.mas_top).offset(-mMoreHalfMargin);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.width.equalTo(scrollView);
    }];
    
    [protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (mSafeAreaInsertBottom > 0) {
            make.bottom.equalTo(self.view).offset(-mSafeAreaInsertBottom);
        } else {
            make.bottom.equalTo(self.view).offset(-mMargin);
        }
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(protocolLabel.preferredMaxLayoutWidth);
        make.height.mas_equalTo(protocolLabel.m_textHeight);
    }];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(contentView);
        make.width.height.mas_equalTo(mMargin + mMoreHalfMargin);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(closeButton.mas_bottom).offset(mMargin);
        make.left.right.equalTo(contentView).inset(mMargin);
        make.height.mas_equalTo(titleLabel.m_textHeight);
    }];
    
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(mMargin * 2);
        make.left.right.equalTo(contentView).inset(mMargin);
        make.height.mas_equalTo(55.0);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTextField.mas_bottom).offset(mMargin);
        make.left.right.equalTo(contentView).inset(mMargin);
        make.height.equalTo(self.accountTextField.mas_height);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(35.0);
        make.left.right.equalTo(contentView).inset(40.0);
        make.height.mas_equalTo(40.0);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(otherLabel);
        make.left.right.equalTo(self.loginButton);
        make.height.mas_equalTo(mLineHeight);
    }];
    
    [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(40.0);
        make.centerX.equalTo(contentView);
        make.width.mas_equalTo(otherLabel.m_textWidth + 40.0);
        make.height.mas_equalTo(otherLabel.m_textHeight);
    }];
    
    if (@available(iOS 13.0, *)) {
        [self.appleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(otherLabel.mas_bottom).offset(mMargin);
            make.left.right.height.equalTo(self.loginButton);
        }];
    }
    
    [thirdLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 13.0, *)) {
            make.top.equalTo(self.appleButton.mas_bottom).offset(mMargin);
        } else {
            make.top.equalTo(otherLabel.mas_bottom).offset(mMargin);
        }
        make.left.right.equalTo(self.loginButton);
        make.height.mas_equalTo(buttonArray.count * 40 + (buttonArray.count - 1) * mMargin);
    }];
    
    if (buttonArray.count >= 2) {
        [buttonArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:mMargin leadSpacing:0 tailSpacing:0];
        
        [buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(thirdLoginView);
        }];
    } else {
        [buttonArray.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(thirdLoginView);
        }];
    }
    
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(contentView);
        make.height.mas_equalTo(1.0);
        if (buttonArray.count > 0) {
            make.top.equalTo(thirdLoginView.mas_bottom);
        } else {
            if (@available(iOS 13.0, *)) {
                make.top.equalTo(self.appleButton.mas_bottom);
            } else {
                make.top.equalTo(otherLabel.mas_bottom);
            }
        }
    }];
}

- (UIButton *)createThirdButtonWithStyle:(MAGLoginButtonStyle)style {
    UIButton *loginButton = [MAGUIFactory buttonWithTarget:nil action:nil];
    loginButton.backgroundColor = UIColor.blackColor.themeColor(UIColor.whiteColor);
    
    UIView *loginView = [MAGUIFactory view];
    loginView.userInteractionEnabled = NO;
    [loginButton addSubview:loginView];
    
    UIImageView *loginImageView = [MAGUIFactory imageView];
    loginImageView.tintColor = UIColor.whiteColor.themeColor(UIColor.blackColor);
    [loginView addSubview:loginImageView];
    
    UILabel *loginLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mBoldFont15 textColor:nil];
    loginLabel.appearanceBindUpdater = ^(UILabel * _Nonnull loginLabel) {
        loginLabel.textColor = UIColor.whiteColor.themeColor(UIColor.blackColor);
    };
    [loginView addSubview:loginLabel];
    
    switch (style) {
        case MAGLoginButtonStyleWechat: {
            [loginButton addTarget:self action:@selector(wechatLogin) forControlEvents:UIControlEventTouchUpInside];
            [loginImageView m_setRenderingModeAlwaysTemplateImageWithURL:MAGResourceLinkManager.wechatLogoImageLink placeholder:mPlaceholdImage];
            loginLabel.text = @"通过 微信 登录";
        }
            break;
        case MAGLoginButtonStyleQQ: {
            [loginButton addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
            [loginImageView m_setRenderingModeAlwaysTemplateImageWithURL:MAGResourceLinkManager.qqLogoImageLink placeholder:mPlaceholdImage];
            loginLabel.text = @"通过 QQ 登录";
        }
            break;
        case MAGLoginButtonStyleTourist: {
            [loginButton addTarget:self action:@selector(touristLogin) forControlEvents:UIControlEventTouchUpInside];
            loginImageView.image = mTouristImage.m_renderingModeAlwaysTemplate;
            loginLabel.text = @"通过 游客 登录";
        }
            break;
    }
    
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.height.equalTo(loginButton);
    }];
    
    [loginImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginView);
        make.centerY.equalTo(loginView);
        make.width.height.mas_equalTo(12.0);
    }];
    
    [loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginImageView.mas_right).offset(mQuarterMargin);
        make.size.mas_equalTo(loginLabel.m_textSize);
        make.centerY.equalTo(loginView);
        make.right.equalTo(loginView);
    }];
    
    return loginButton;
}

@end

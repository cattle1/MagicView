//
//  MAGAboutUSViewController1.m
//  MagicView
//
//  Created by LL on 2021/10/21.
//

#import "MAGAboutUSViewController1.h"

@interface MAGAboutUSViewController1 ()

@end

@implementation MAGAboutUSViewController1

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setStatusBarLightStyle];
}

- (void)initialize {
    [super initialize];
    
    [self setNavigationBarTitle:@"关于我们"];
}

- (void)createSubviews {
    [super createSubviews];
    
    UIImageView *appLogoImageView = [MAGUIFactory imageViewWithBackgroundColor:nil image:[UIImage imageNamed:mAppLogoName] cornerRadius:12.0];
    [self.view addSubview:appLogoImageView];
    
    UILabel *appNameLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mBoldFont23 textColor:mTextColor1];
    appNameLabel.text = mAppName;
    appNameLabel.textAlignment = NSTextAlignmentCenter;
    appNameLabel.numberOfLines = 0;
    appNameLabel.preferredMaxLayoutWidth = kScreenWidth - 2 * mMargin;
    [self.view addSubview:appNameLabel];
    
    YYLabel *protocolLabel = [MAGUIFactory yyLabel];
    protocolLabel.numberOfLines = 0;
    protocolLabel.preferredMaxLayoutWidth = appNameLabel.preferredMaxLayoutWidth;
    
    NSString *userProtocol = @"用户协议";
    NSString *privacyProtocol = @"隐私政策";
    NSString *emailString = @"联系邮箱";
    
    NSMutableAttributedString *protocolAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ · %@ · %@ ", userProtocol, privacyProtocol, emailString] attributes:@{NSFontAttributeName : mFont13, NSForegroundColorAttributeName : mTextColor2}];
    [protocolAttr setAttribute:YYTextUnderlineAttributeName value:[YYTextDecoration decorationWithStyle:YYTextLineStyleSingle width:@(1.0) color:mTextColor2] range:[protocolAttr.string rangeOfString:userProtocol]];
    [protocolAttr setAttribute:YYTextUnderlineAttributeName value:[YYTextDecoration decorationWithStyle:YYTextLineStyleSingle width:@(1.0) color:mTextColor2] range:[protocolAttr.string rangeOfString:privacyProtocol]];
    [protocolAttr setAttribute:YYTextUnderlineAttributeName value:[YYTextDecoration decorationWithStyle:YYTextLineStyleSingle width:@(1.0) color:mTextColor2] range:[protocolAttr.string rangeOfString:emailString]];
    protocolAttr.alignment = NSTextAlignmentCenter;
    
    [protocolAttr setTextHighlightRange:[protocolAttr.string rangeOfString:userProtocol] color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [UIApplication.sharedApplication openURL:mUserProtocolLink.m_URL options:@{} completionHandler:nil];
        [MAGClickAgent event:@"用户点击了关于页面的用户协议" attributes:@{@"url" : mUserProtocolLink}];
    }];
    
    [protocolAttr setTextHighlightRange:[protocolAttr.string rangeOfString:privacyProtocol] color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [UIApplication.sharedApplication openURL:mPrivacyProtocolLink.m_URL options:@{} completionHandler:nil];
        [MAGClickAgent event:@"用户点击了关于页面的隐私协议" attributes:@{@"url" : mPrivacyProtocolLink}];
    }];
    
    [protocolAttr setTextHighlightRange:[protocolAttr.string rangeOfString:emailString] color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = MAGUserInfoManager.userInfo.email;
        [mMainWindow m_showNormalHUDFromText:@"已复制邮箱地址"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:MAGUserInfoManager.userInfo.email] options:@{} completionHandler:nil];
            [MAGClickAgent event:@"用户点击了关于页面的邮箱" attributes:@{@"email" : MAGUserInfoManager.userInfo.email}];
        });
    }];
    
    protocolLabel.attributedText = protocolAttr;
    [self.view addSubview:protocolLabel];
    
    UILabel *copyrightLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mFont13 textColor:mTextColor2];
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    NSDate *date = [NSDate date];
    copyrightLabel.text = [NSString stringWithFormat:@"Copyright © 1998 - %zd %@ All rights reserved.", date.year, mAppName];
    copyrightLabel.numberOfLines = 0;
    copyrightLabel.preferredMaxLayoutWidth = appNameLabel.preferredMaxLayoutWidth;
    [self.view addSubview:copyrightLabel];
    
    UILabel *copyrightTipsLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mFont13 textColor:mTextColor2];
    copyrightTipsLabel.textAlignment = NSTextAlignmentCenter;
    copyrightTipsLabel.text = [NSString stringWithFormat:@"%@ %@", mAppName, @"版权所有"];
    copyrightTipsLabel.numberOfLines = 0;
    copyrightTipsLabel.preferredMaxLayoutWidth = appNameLabel.preferredMaxLayoutWidth;
    [self.view addSubview:copyrightTipsLabel];
    
    
    [appLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).offset(25.0);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(80);
    }];
    
    [appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(appLogoImageView.mas_bottom).offset(mHalfMargin);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(appNameLabel.preferredMaxLayoutWidth);
        make.height.mas_equalTo(appNameLabel.m_textHeight);
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
    
    [copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(protocolLabel.mas_top).offset(-mHalfMargin);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(copyrightLabel.preferredMaxLayoutWidth);
        make.height.mas_equalTo(copyrightLabel.m_textHeight);
    }];
    
    [copyrightTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(copyrightLabel.mas_top).offset(-mHalfMargin);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(copyrightTipsLabel.preferredMaxLayoutWidth);
        make.height.mas_equalTo(copyrightTipsLabel.m_textHeight);
    }];
}

@end

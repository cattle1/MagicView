//
//  MAGLoginViewController.h
//  MagicView
//
//  Created by LL on 2021/10/16.
//

#import "MAGViewController.h"

#import <AuthenticationServices/AuthenticationServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAGLoginViewController : MAGViewController<UITextFieldDelegate>

@property (nonatomic, weak) UITextField *accountTextField;

@property (nonatomic, weak) UITextField *passwordTextField;

@property (nonatomic, weak) UIButton *loginButton;

@property (nonatomic, weak) ASAuthorizationAppleIDButton *appleButton API_AVAILABLE(ios(13.0));


+ (instancetype)loginViewController;

+ (void)presentLoginViewController:(void (^ _Nullable) (BOOL isSuccess))block;

- (void)touristLogin;

- (void)accountLogin;

- (void)appleLogin;

- (void)wechatLogin;

- (void)qqLogin;

- (void)textFieldEditingChanged;

@end

NS_ASSUME_NONNULL_END

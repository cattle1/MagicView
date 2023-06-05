//
//  MAGAccountCancellationViewController.h
//  MagicView
//
//  Created by LL on 2022/1/24.
//

#import "MAGViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGAccountCancellationViewController : MAGViewController

/// 注销账号的规则说明
@property (nonatomic, copy, readonly) NSArray<NSString *> *ruleArray;

+ (instancetype)accountCancellationViewController;

/// 当用户点击“确认注销”按钮时调用
- (void)accountCancellationEvent;

@end

NS_ASSUME_NONNULL_END

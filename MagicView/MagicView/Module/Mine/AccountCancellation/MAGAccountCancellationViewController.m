//
//  MAGAccountCancellationViewController.m
//  MagicView
//
//  Created by LL on 2022/1/24.
//

#import "MAGAccountCancellationViewController.h"

#import "MAGAccountCancellationViewController1.h"

@implementation MAGAccountCancellationViewController

@synthesize ruleArray = _ruleArray;

+ (instancetype)accountCancellationViewController {
    return [[MAGAccountCancellationViewController1 alloc] init];
}

- (void)initialize {
    [super initialize];
    
    [self setNavigationBarTitle:@"注销账号"];
}

- (void)accountCancellationEvent {
    if (mIsCanPayment) {
        if (MAGUserInfoManager.userInfo.remain > 0) {
            [mMainWindow m_showErrorHUDFromText:@"注销失败，请先消耗掉账号中的余额。"];
            return;
        }
        
        if (MAGUserInfoManager.userInfo.isVIP) {
            [mMainWindow m_showErrorHUDFromText:@"注销失败，请等会员过期再次尝试。"];
            return;
        }
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"注销成功后将无法恢复原账号，请谨慎操作!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    mWeakobj(self)
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive
                                                       handler:^(UIAlertAction * _Nonnull action) {
        MAGProgressHUD *hud = [mMainWindow m_showDarkHUDFromText:@"正在注销"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(mRandomFloat(1.5, 3.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *userToken = MAGUserInfoManager.userInfo.user_token;
            
            // 删除本地用户信息
            NSString *path = [MAGFileManager userInfoFilePath:userToken];
            [mFileManager removeItemAtPath:path error:nil];
            
            {// 删除本地保存的账号和密码
                NSMutableDictionary *accountDict = [[NSDictionary m_dictionaryWithContentsOfFile:MAGFileManager.accountPath] mutableCopy];
                if (accountDict) {
                    [accountDict removeObjectForKey:userToken];
                    [accountDict m_writeToFile:MAGFileManager.accountPath];
                }
            }
            
            // 删除小说购买记录
            [mFileManager removeItemAtPath:MAGFileManager.bookPurchaseFilePath error:nil];
            
            [MAGUserInfoManager logout];
            
            [hud hideAnimated:YES];
            [mMainWindow m_showSuccessHUDFromText:@"注销成功"];
            [mNotificationCenter postNotificationName:MAGUserAccountCancellationSuccessNotification object:nil];
            [weak_self.navigationController popViewControllerAnimated:YES];
        });
    }];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Getter
- (NSArray<NSString *> *)ruleArray {
    if (_ruleArray == nil) {
        NSMutableArray *t_array = [@[
            @"注销后您的账号将再也无法找回，数据和信息都将无法恢复，请慎重!",
            @"重新注册后将无法查看原账号的相关信息，例如头像、昵称等等。",
        ] mutableCopy];
        
        if (mIsCanPayment) {
            [t_array insertObject:@"如果您曾经购买过任何商品，请先将它们消耗掉或者等它们过期，否则不能注销帐号。" atIndex:0];
        }
        
        _ruleArray = [t_array copy];
    }
    return _ruleArray;
}

@end

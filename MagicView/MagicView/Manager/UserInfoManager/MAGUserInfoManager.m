//
//  MAGUserInfoManager.m
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import "MAGUserInfoManager.h"

#import "MAGImport.h"
#import "MAGNetworkRequestManager.h"

@implementation MAGUserInfoManager

+ (void)initialize {
    NSString *userToken = [mUserDefault objectForKey:mCurrentUserToken];
    [self touristLogin:userToken];
}

+ (MAGUserInfoModel *)userInfo {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return MAGUserInfoModel.shareInstance;
#pragma clang diagnostic pop
}

+ (BOOL)isLogin {
    return !mObjectIsEmpty(MAGUserInfoManager.userInfo.user_token);
}

+ (void)logout {
    if (!MAGUserInfoManager.isLogin) return;
        
    MAGUserInfoManager.userInfo.user_token = nil;
    MAGUserInfoManager.userInfo.nickname = nil;
    MAGUserInfoManager.userInfo.avatar = nil;
    MAGUserInfoManager.userInfo.email = nil;
    MAGUserInfoManager.userInfo.goldRemain = 0;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [mNotificationCenter postNotificationName:MAGUserDidLogoutNotification object:nil];
    });
    
    [MAGClickAgent event:@"用户退出了登录"];
}

+ (BOOL)touristLogin:(NSString * _Nullable)token {
    if (mObjectIsEmpty(token)) return NO;
    if ([MAGUserInfoManager.userInfo.user_token isEqualToString:token]) return NO;
    
    [self logout];
    
    [self mp_autoLoginWithToken:token];
    [mUserDefault setObject:token forKey:mCurrentUserToken];
    
    mDispatchAsyncOnMainQueue([mNotificationCenter postNotificationName:MAGUserLoginSuccessNotification object:nil]);
    
    [MAGClickAgent event:@"用户登录成功"];
    
    return YES;
}

+ (void)updateUserInfo:(MAGUserInfoModel *)model {
    [[NSUserDefaults standardUserDefaults] setInteger:model.remain forKey:mUserGoldRemain];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [model m_writeToFile:[MAGFileManager userInfoFilePath:model.user_token]];
    });
}


#pragma mark - Private
+ (void)mp_autoLoginWithToken:(NSString *)token {
    if (token == nil) return;
    
    [MAGNetworkRequestManager POST:mTourists_Login parameters:@{@"udid": token} modelClass:MAGUserInfoModel.class success:^(BOOL isSuccess, MAGUserInfoModel  *t_model, BOOL isCache, MAGNetworkRequestModel * _Nonnull requestModel) {
        if (isSuccess) {
            [MAGUserInfoManager updateUserInfo:t_model];

            NSString *path = [MAGFileManager userInfoFilePath:token];
            if ([mFileManager fileExistsAtPath:path]) {
                NSDictionary *dict = [NSDictionary m_dictionaryWithContentsOfFile:path];
                [t_model modelSetWithDictionary:dict];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

+ (nullable NSArray<NSString *> *)chineseNameArray {
    if ([mFileManager fileExistsAtPath:MAGFileManager.chineseNicknameFilePath]) {
        static NSArray<NSString *> *chineseNameArray;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSString *nickname = [NSString stringWithContentsOfFile:MAGFileManager.chineseNicknameFilePath encoding:NSUTF8StringEncoding error:nil];
            chineseNameArray = [nickname componentsSeparatedByString:@"\n"];
        });
        return chineseNameArray;
    } else {
        return nil;
    }
}

+ (nullable NSArray<NSString *> *)englishNameArray {
    if ([mFileManager fileExistsAtPath:MAGFileManager.englishNicknameFilePath]) {
        static NSArray<NSString *> *englishNameArray;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSString *nickname = [NSString stringWithContentsOfFile:MAGFileManager.englishNicknameFilePath encoding:NSUTF8StringEncoding error:nil];
            englishNameArray = [nickname componentsSeparatedByString:@"\n"];
        });
        return englishNameArray;
    } else {
        return nil;
    }
}

@end

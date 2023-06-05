//
//  MAGUserInfoManager.h
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import <Foundation/Foundation.h>

#import "MAGUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGUserInfoManager : NSObject

@property (nonatomic, class, readonly) MAGUserInfoModel *userInfo;

@property (nonatomic, class, readonly) BOOL isLogin;

+ (void)logout;

/// 使用唯一标识符登录账号
+ (BOOL)touristLogin:(NSString * _Nullable)token;

+ (void)updateUserInfo:(MAGUserInfoModel *)model;

@end

NS_ASSUME_NONNULL_END

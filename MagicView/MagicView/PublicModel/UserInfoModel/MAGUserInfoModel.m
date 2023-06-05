//
//  MAGUserInfoModel.m
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import "MAGUserInfoModel.h"

#import "MAGImport.h"

@implementation MAGUserInfoModel

+ (MAGUserInfoModel *)shareInstance {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static MAGUserInfoModel *_userInfoModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userInfoModel = [super allocWithZone:zone];
    });
    return _userInfoModel;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[MAGUserInfoModel alloc] init];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[MAGUserInfoModel alloc] init];
}

- (BOOL)isVIP {
    return MAGUserInfoManager.userInfo.memberEndTime > mTimestampSecond;
}

@end

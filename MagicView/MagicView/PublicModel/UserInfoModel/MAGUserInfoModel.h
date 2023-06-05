//
//  MAGUserInfoModel.h
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAGUserInfoModel : NSObject<NSCopying, NSMutableCopying>

@property (nonatomic, assign, getter=isVIP, readonly) BOOL vip;

@property (nonatomic, copy, nullable) NSString *uid;

@property (nonatomic, assign) NSInteger goldRemain;

@property (nonatomic, assign) NSInteger remain;

@property (nonatomic, copy, nullable) NSString *avatar;

@property (nonatomic, copy, nullable) NSString *nickname;

@property (nonatomic, copy, nullable) NSString *email;

@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, copy, nullable) NSString *user_token;

@property (nonatomic, copy) NSString *unit;

@property (nonatomic, assign) NSInteger memberEndTime;

+ (MAGUserInfoModel *)shareInstance;

@end

NS_ASSUME_NONNULL_END

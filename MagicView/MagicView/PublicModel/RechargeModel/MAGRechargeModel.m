//
//  MAGRechargeModel.m
//  MagicView
//
//  Created by LL on 2021/10/19.
//

#import "MAGRechargeModel.h"

#import "MAGUserInfoModel.h"
#import "MAGPurchaseManager.h"
#import "MAGImport.h"

@implementation MAGRechargeModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"memberList" : MAGRechargeItemModel.class,
        @"rechargeList" : MAGRechargeItemModel.class,
    };
}

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
        @"memberList" : @"vip",
        @"rechargeList" : @"recharge",
    };
}

@end


@implementation MAGRechargeItemModel

+ (instancetype)rechargeItemWithAppleID:(NSString *)appleID {
    MAGRechargeItemModel *item = [[self alloc] init];
    item.appleID = appleID;
    return item;
}

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
        @"appleID" : @"apple_id",
        @"fatPrice" : @"fat_price",
        @"subTitle" : @"sub_title",
        @"goldNumber" : @"gold_num",
        @"memberDuration" : @"times",
        @"silverNumer" : @"silver_num",
    };
}

- (NSUInteger)hash {
    return self.appleID.hash;
}

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (object == nil) return NO;
    if (![object isMemberOfClass:MAGRechargeItemModel.class]) return NO;
    
    return ([object hash] == self.hash);
}

@end

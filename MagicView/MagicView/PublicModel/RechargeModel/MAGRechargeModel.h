//
//  MAGRechargeModel.h
//  MagicView
//
//  Created by LL on 2021/10/19.
//

#import <Foundation/Foundation.h>

@class MAGRechargeItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface MAGRechargeModel : NSObject

@property (nonatomic, copy) NSArray<MAGRechargeItemModel *> *memberList;

@property (nonatomic, copy) NSArray<MAGRechargeItemModel *> *rechargeList;

@end


@interface MAGRechargeItemModel : NSObject

@property (nonatomic, copy) NSString *appleID;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;

/// 价格全称，例如$8.99
@property (nonatomic, copy) NSString *fatPrice;

/// 不带单位的价格，例如8.99
@property (nonatomic, copy) NSString *price;

/// 充值所获得的书币数量
@property (nonatomic, assign) NSInteger goldNumber;

/// 充值所赠送的书币数量
@property (nonatomic, assign) NSInteger silverNumer;

/// 充值所获得的会员时长(秒)
@property (nonatomic, assign) NSInteger memberDuration;


+ (instancetype)rechargeItemWithAppleID:(NSString *)appleID;

@end

NS_ASSUME_NONNULL_END

//
//  MAGRechargeRecordModel.h
//  MagicView
//
//  Created by LL on 2021/10/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAGRechargeRecordModel : NSObject

@property (nonatomic, copy) NSString *appleID;

@property (nonatomic, assign) NSInteger transactionDate;

@property (nonatomic, copy) NSString *title;

/// 价格全称，例如$8.99
@property (nonatomic, copy) NSString *fatPrice;

/// 不带单位的价格，例如8.99
@property (nonatomic, copy) NSString *price;

@end

NS_ASSUME_NONNULL_END

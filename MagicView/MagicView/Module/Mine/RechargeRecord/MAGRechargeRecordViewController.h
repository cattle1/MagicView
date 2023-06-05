//
//  MAGRechargeViewController.h
//  MagicView
//
//  Created by LL on 2021/10/20.
//

#import "MAGViewController.h"

#import "MAGRechargeRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGRechargeRecordViewController : MAGViewController

@property (nonatomic, copy, readonly) NSArray<MAGRechargeRecordModel *> *rechargeRecord;


@property (nonatomic, weak) UILabel *tipsLabel;

+ (instancetype)rechargeRecordViewController;

@end

NS_ASSUME_NONNULL_END

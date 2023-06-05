//
//  MAGRechargeViewController.h
//  MagicView
//
//  Created by LL on 2021/10/19.
//

#import "MAGViewController.h"

#import "MAGRechargeModel.h"
#import "MAGIAPManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGRechargeViewController : MAGViewController

@property (nonatomic, assign) BOOL haveMember;

@property (nonatomic, assign) BOOL haveRecharge;

@property (nonatomic, copy) NSArray<MAGRechargeItemModel *> *list;

@property (nonatomic, strong) NSArray<NSString *> *rechargeTips;

@property (nonatomic, strong, readonly) MAGIAPManager *IAPManager;


/// 恢复购买按钮。
/// 默认情况下如果包含金币购买功能则会显示按钮，反之不显示。
@property (nonatomic, weak) UIButton *restoreButton;


+ (instancetype)rechargeViewController;

- (void)requestProduct:(MAGRechargeItemModel *)item;

- (void)rechargeSuccess;

/// 当用户点击“恢复”按钮时触发。
- (void)restoreEvent;

@end

NS_ASSUME_NONNULL_END

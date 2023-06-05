//
//  MAGRechargeViewController.m
//  MagicView
//
//  Created by LL on 2021/10/19.
//

#import "MAGRechargeViewController.h"

#import "MAGRechargeRecordModel.h"
#import "MAGLoginViewController.h"
#import "MAGRechargeViewController1.h"

@interface MAGRechargeViewController ()<MAGIAPManagerDelegate>

@property (nonatomic, strong) MAGRechargeItemModel *rechargeItem;

@property (nonatomic, strong) MAGRechargeModel *rechargeModel;


@property (nonatomic, strong) MAGProgressHUD *rechargeHUD;

@end

@implementation MAGRechargeViewController

@synthesize IAPManager = _IAPManager;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [MAGClickAgent appendDidAppearViewControllerName:@"充值页面"];
    [MAGClickAgent event:@"用户进入充值页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MAGClickAgent event:@"用户离开充值页面"];
}

+ (instancetype)rechargeViewController {
    return [[MAGRechargeViewController1 alloc] init];
}

- (void)initialize {
    [super initialize];
    
    _list = @[];
    
    _rechargeTips = @[
        @"充值说明",
        @"充值成功后10分钟内还没到账，请退出APP重新打开进行尝试",
        @"充值的商品仅限于在APP内消费或使用",
        @"所有商品与活动均与设备制作商Apple Inc.无关",
    ];
    
    [self setBringNavigationBarToFront:YES];
}

- (void)createSubviews {
    [super createSubviews];
    
    UIButton *restoreButton = [MAGUIFactory buttonWithType:UIButtonTypeSystem backgroundColor:nil font:mFont15 textColor:mNavBarTintColor target:self action:@selector(restoreEvent)];
    self.restoreButton = restoreButton;
    restoreButton.hidden = YES;
    [restoreButton setTitle:@"恢复" forState:UIControlStateNormal];
    [self.navigationBar addSubview:restoreButton];
    
    
    [restoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navigationBar).offset(-mHalfMargin);
        make.centerY.equalTo(self.navigationBar.titleLabel);
        make.size.mas_equalTo(restoreButton.m_textSize);
    }];
}

- (void)netRequest {
    [super netRequest];
    
    MAGProgressHUD *hud = [self.view m_showClearHUDFromText:nil];
    
    mWeakobj(self)
    [MAGNetworkRequestManager POST:mGoodsListLink parameters:nil modelClass:MAGRechargeModel.class success:^(BOOL isSuccess, MAGRechargeModel * _Nullable t_model, BOOL isCache, MAGNetworkRequestModel * _Nonnull requestModel) {
        [hud hideAnimated:YES];
        if (isSuccess) {
            weak_self.rechargeModel = t_model ?: [[MAGRechargeModel alloc] init];
            NSArray *memberIdentifier = [t_model.memberList valueForKeyPath:mKEYPATH(t_model.memberList.firstObject, appleID)];
            NSArray *rechargeIdentifier = [t_model.rechargeList valueForKeyPath:mKEYPATH(t_model.rechargeList.firstObject, appleID)];
            
            [weak_self.IAPManager verifyProductsWithIdentifiers:[memberIdentifier arrayByAddingObjectsFromArray:rechargeIdentifier] complete:^(NSArray<NSString *> * _Nonnull identifiers) {
                [weak_self mp_updateViewWithIdentifiers:identifiers];
                if (identifiers.count > 0) return;

                // 检查固定商品是否存在
                NSMutableArray<MAGRechargeItemModel *> *t_array = [NSMutableArray array];
                for (NSString *identifier in MAGIAPManager.fixedGoodsIdentifier) {
                    MAGRechargeItemModel *itemModel = [MAGRechargeItemModel rechargeItemWithAppleID:identifier];
                    [t_array addObject:itemModel];
                }
                weak_self.rechargeModel.rechargeList = [t_array copy];

                [weak_self.IAPManager verifyProductsWithIdentifiers:MAGIAPManager.fixedGoodsIdentifier complete:^(NSArray<NSString *> * _Nonnull identifiers) {
                    [weak_self mp_updateViewWithIdentifiers:identifiers];
                }];
            }];
        } else {
            [mMainWindow m_showErrorHUDFromText:requestModel.msg ?: @"加载失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [mMainWindow m_showErrorHUDFromError:error];
    }];
}

- (void)requestProduct:(MAGRechargeItemModel *)item {
    if (!MAGUserInfoManager.isLogin) {
        [MAGLoginViewController presentLoginViewController:nil];
        return;
    }
    
    self.rechargeHUD = [mMainWindow m_showDarkHUDFromText:nil];
    
    self.rechargeItem = item;
    [self.IAPManager requestPaymentWithIdentifier:item.appleID];
    
    [MAGClickAgent event:@"用户点击了商品" attributes:@{@"apple_id" : item.appleID ?: @"NULL", @"price" : item.fatPrice ?: @"NULL", @"title" : item.title ?: @"NULL"}];
}

- (void)rechargeSuccess {}

- (void)restoreEvent {
    MAGProgressHUD *hud = [mMainWindow m_showDarkHUDFromText:@"加载中..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(mRandomFloat(1.0, 2.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
        [mMainWindow m_showNormalHUDFromText:@"没有可恢复的商品"];
    });
}


#pragma mark - Private
- (void)mp_updateViewWithIdentifiers:(NSArray<NSString *> *)identifiers {
    if (identifiers.count == 0) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray<MAGRechargeItemModel *> *t_array = [NSMutableArray array];
        
        {// 检查是否有会员商品
            BOOL haveMember = NO;
            for (MAGRechargeItemModel *obj in self.rechargeModel.memberList) {
                if ([identifiers containsObject:obj.appleID]) {
                    haveMember = YES;
                    [t_array addObject:obj];
                }
            }
            self.haveMember = haveMember;
        }
        
        {// 检查是否有充值商品
            BOOL haveRecharge = NO;
            for (MAGRechargeItemModel *obj in self.rechargeModel.rechargeList) {
                if ([identifiers containsObject:obj.appleID]) {
                    haveRecharge = YES;
                    [t_array addObject:obj];
                }
            }
            self.haveRecharge = haveRecharge;
        }
        
        // 校验并修改商品价格和标题
        for (MAGRechargeItemModel *itemModel in t_array) {
            SKProduct *product = [self.IAPManager productWithIdentifier:itemModel.appleID];
            if (product) {
                itemModel.price = [product.price stringValue];
                itemModel.fatPrice = [NSString stringWithFormat:@"%@%@", product.priceLocale.currencySymbol, itemModel.price];
                if (mObjectIsEmpty(itemModel.title)) {
                    itemModel.title = product.localizedTitle;
                }
                if (mObjectIsEmpty(itemModel.subTitle)) {
                    itemModel.subTitle = product.localizedDescription;
                }
            }
        }
        
        self.list = [t_array copy];
        self.view.hidden = NO;
    });
}


#pragma mark - MAGIAPManagerDelegate
- (void)transcationStatus:(MAGIAPManager *)manager state:(MAGIAPState)state tips:(NSString *)tips {
    [self.rechargeHUD hideAnimated:YES];
    
    NSMutableDictionary *attributes = [@{@"apple_id" : self.rechargeItem.appleID ?: @"NULL", @"price" : self.rechargeItem.fatPrice ?: @"NULL", @"title" : self.rechargeItem.title ?: @"NULL"} mutableCopy];
    if (@available(iOS 13.0, *)) {
        [attributes setObject:SKPaymentQueue.defaultQueue.storefront.countryCode forKey:@"country_code"];
        [attributes setObject:SKPaymentQueue.defaultQueue.storefront.identifier forKey:@"store_identifier"];
    }
    
    switch (state) {
        case MAGIAPStateSuccess: {
            if (self.rechargeItem.goldNumber > 0) {
                MAGUserInfoManager.userInfo.remain += self.rechargeItem.goldNumber + self.rechargeItem.silverNumer;
            } else {
                if (MAGUserInfoManager.userInfo.isVIP) {
                    MAGUserInfoManager.userInfo.memberEndTime += self.rechargeItem.memberDuration;
                } else {
                    MAGUserInfoManager.userInfo.memberEndTime = mTimestampSecond + self.rechargeItem.memberDuration;
                }
            }
            [MAGUserInfoManager updateUserInfo:MAGUserInfoManager.userInfo];

            [mMainWindow m_showSuccessHUDFromText:@"充值成功"];
            [self rechargeSuccess];
            [mNotificationCenter postNotificationName:MAGUserPurchaseSuccessNotification object:nil];
            
            // 保存充值记录
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                MAGRechargeRecordModel *recordModel = [[MAGRechargeRecordModel alloc] init];
                NSDictionary *record = @{
                    mKEYPATH(recordModel, transactionDate) : @(mTimestampSecond),
                    mKEYPATH(recordModel, appleID) : self.rechargeItem.appleID ?: @"",
                    mKEYPATH(recordModel, title) : self.rechargeItem.title ?: @"",
                    mKEYPATH(recordModel, fatPrice) : self.rechargeItem.fatPrice ?: @"",
                    mKEYPATH(recordModel, price) : self.rechargeItem.price ?: @"",
                };
                
                NSMutableArray<NSDictionary *> *recordArray = [[NSArray m_arrayWithContentsOfFile:MAGFileManager.rechargeRecordFilePath] mutableCopy];
                if (recordArray == nil) recordArray = [NSMutableArray array];
                
                [recordArray insertObject:record atIndex:0];
                
                [recordArray m_writeToFile:MAGFileManager.rechargeRecordFilePath];
            });
            
            [MAGClickAgent event:@"用户充值成功" attributes:attributes];
        }
            break;
        case MAGIAPStateCancel: {
            [mMainWindow m_showNormalHUDFromText:@"取消充值"];
            
            [MAGClickAgent event:@"用户取消充值" attributes:attributes];
        }
            break;
        case MAGIAPStateError: {
            [mMainWindow m_showErrorHUDFromText:tips ?: @"充值失败"];
            
            [MAGClickAgent event:@"用户充值失败" attributes:attributes];
        }
            break;
        case MAGIAPStateNoPermission: {
            [mMainWindow m_showErrorHUDFromText:@"没有支付权限"];
            
            [MAGClickAgent event:@"用户没有支付权限" attributes:attributes];
        }
            break;
        case MAGIAPStateNoGoods: {
            [mMainWindow m_showErrorHUDFromText:@"商品不存在"];
            
            [MAGClickAgent event:@"商品不存在" attributes:attributes];
        }
            break;
    }
}

#pragma mark - Getter/Setter
- (MAGIAPManager *)IAPManager {
    if (_IAPManager == nil) {
        _IAPManager = [MAGIAPManager shareInstance];
        _IAPManager.delegate = self;
    }
    return _IAPManager;
}

- (void)setHaveMember:(BOOL)haveMember {
    _haveMember = haveMember;
    
    if (_haveMember) {
        self.rechargeTips = [self.rechargeTips arrayByAddingObject:@"开通会员后可以在会员期限内免费阅读所有付费书籍内容"];
    }
}

- (void)setHaveRecharge:(BOOL)haveRecharge {
    _haveRecharge = haveRecharge;
    
    if (_haveRecharge) {
        self.rechargeTips = [self.rechargeTips arrayByAddingObject:@"充值所获得的书币可以用于购买书籍的付费章节内容，书币永久有效"];
        self.restoreButton.hidden = NO;
    }
}

@end

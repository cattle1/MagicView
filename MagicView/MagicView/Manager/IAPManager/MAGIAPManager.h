//
//  MAGIAPManager.h
//  MagicView
//
//  Created by LL on 2021/10/19.
//

#import <Foundation/Foundation.h>

#import <StoreKit/StoreKit.h>

@class MAGIAPManager;

NS_ASSUME_NONNULL_BEGIN

/// 交易状态
typedef NS_ENUM(NSInteger, MAGIAPState) {
    MAGIAPStateError        = 0,/**< 苹果返回了错误信息*/
    MAGIAPStateNoPermission = 1,/**< 用户没有支付权限*/
    MAGIAPStateCancel       = 2,/**< 用户取消交易*/
    MAGIAPStateSuccess      = 3,/**< 交易成功*/
    MAGIAPStateNoGoods      = 4,/**< 商品不存在*/
};

@protocol MAGIAPManagerDelegate <NSObject>

/// 交易状态
/// @param tips 如果 state 是 MAGIAPStateError，那么 tips 可能会是苹果返回的错误信息
- (void)transcationStatus:(MAGIAPManager *)manager state:(MAGIAPState)state tips:(nullable NSString *)tips;

@end

@interface MAGIAPManager : NSObject

@property (nonatomic, weak) id<MAGIAPManagerDelegate> delegate;

/// 固定商品标识符
/// @discussion 当用户选择了第3方支付，但是审核又需要内购时使用
@property (nonatomic, class, readonly) NSArray<NSString *> *fixedGoodsIdentifier;

+ (instancetype)shareInstance;

/// 从 App Store 校验商品是否存在
/// @param identifiers 需要校验的商品标识符
/// @param complete 校验通过的商品标识符，complete可能会在子线程中回调
- (void)verifyProductsWithIdentifiers:(NSArray<NSString *> *)identifiers complete:(void (^)(NSArray<NSString *> *identifiers))complete;

- (void)requestPaymentWithIdentifier:(NSString *)identifier;

/// 根据唯一标识符获取App Store上的商品信息
- (nullable SKProduct *)productWithIdentifier:(NSString *)identifier;

/// 开启监听并移除其他监听
+ (void)startManager;

/// 结束监听并添加其他监听
+ (void)stopManager;

@end

NS_ASSUME_NONNULL_END

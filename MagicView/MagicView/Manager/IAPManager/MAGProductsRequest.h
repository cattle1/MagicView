//
//  MAGProductsRequest.h
//  MagicView
//
//  Created by LL on 2021/10/19.
//

#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAGProductsRequest : SKProductsRequest

/// 根据商品唯一标识符从 App Store 获取商品信息
+ (void)requestProductsWithIdentifiers:(NSArray<NSString *> *)identifiers complete:(void (^)(SKProductsResponse *response))complete;

@end

NS_ASSUME_NONNULL_END

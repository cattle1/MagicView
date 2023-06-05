//
//  MAGIAPManager.m
//  MagicView
//
//  Created by LL on 2021/10/19.
//

#import "MAGIAPManager.h"

#import "MAGImport.h"
#import "MAGProductsRequest.h"

@interface MAGIAPManager ()<SKPaymentTransactionObserver>

@property (nonatomic, strong) NSMutableDictionary<NSString *, SKProduct *> *productCache;

@property (nonatomic, readonly) SKPaymentQueue *paymentQueue;

@property (nonatomic, strong) NSMutableArray<id <SKPaymentTransactionObserver>> *transactionObserverArray;

@end

@implementation MAGIAPManager

static MAGIAPManager *_IAPManager;
+ (void)initialize {
    [self m_addNotificationWithName:MAGSwitchFormalStateNotification selector:@selector(stopManager)];
}

+ (instancetype)shareInstance {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _IAPManager = [super allocWithZone:zone];
    });
    
    return _IAPManager;
}

+ (void)startManager {
    MAGIAPManager *manager = [self shareInstance];
    if (@available(iOS 14.0, *)) {
        NSArray<id <SKPaymentTransactionObserver>> *transactionObservers = [SKPaymentQueue defaultQueue].transactionObservers;
        for (id<SKPaymentTransactionObserver> obj in transactionObservers) {
            [manager.transactionObserverArray addObject:obj];
            [[SKPaymentQueue defaultQueue] removeTransactionObserver:obj];
        }
    }
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:manager];
}

+ (void)stopManager {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:_IAPManager];
    for (id<SKPaymentTransactionObserver> obj in _IAPManager.transactionObserverArray) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:obj];
    }
    [_IAPManager.transactionObserverArray removeAllObjects];
}

- (void)verifyProductsWithIdentifiers:(NSArray<NSString *> *)identifiers complete:(void (^)(NSArray<NSString *> *identifiers))complete {
    if (mObjectIsEmpty(identifiers)) {
        !complete ?: complete(@[]);
        return;
    }
    
    if (self.productCache.count > 0) {
        NSMutableArray<NSString *> *verifyIdentifiers = [NSMutableArray array];
        for (NSString *identifier in identifiers) {
            if ([self.productCache containsObjectForKey:identifier]) {
                [verifyIdentifiers addObject:identifier];
            }
        }
        !complete ?: complete([verifyIdentifiers copy]);
        return;
    }
    
    [MAGProductsRequest requestProductsWithIdentifiers:identifiers complete:^(SKProductsResponse * _Nonnull response) {
        NSArray<SKProduct *> *products = response.products;
        for (SKProduct *product in products) {
            [self.productCache setObject:product forKey:product.productIdentifier];
        }
        
        NSArray<NSString *> *identifiers = [products valueForKeyPath:mKEYPATH(products.firstObject, productIdentifier)];
        !complete ?: complete(identifiers);
    }];
}

- (void)requestPaymentWithIdentifier:(NSString *)identifier {
    if (mObjectIsEmpty(identifier)) {
        [self mp_requestComplete:MAGIAPStateNoGoods tips:nil];
        return;
    }
    
    if (![SKPaymentQueue canMakePayments]) {
        [self mp_requestComplete:MAGIAPStateNoPermission tips:nil];
        return;
    }
    
    SKProduct *product = self.productCache[identifier];
    if (product) {
        [self.paymentQueue addPayment:[SKPayment paymentWithProduct:product]];
    } else {
        [self mp_requestComplete:MAGIAPStateNoGoods tips:nil];
    }
}

- (nullable SKProduct *)productWithIdentifier:(NSString *)identifier {
    return self.productCache[identifier];
}


#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing: {// 正在交易
            }
                break;
            case SKPaymentTransactionStatePurchased: {// 交易成功
                [self mp_requestComplete:MAGIAPStateSuccess tips:nil];
                [self.paymentQueue finishTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateFailed: {// 交易失败
                if (transaction.error.code == SKErrorPaymentCancelled) {
                    [self mp_requestComplete:MAGIAPStateCancel tips:nil];
                } else {
                    [self mp_requestComplete:MAGIAPStateError tips:transaction.error.localizedDescription];
                }
                [self.paymentQueue finishTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateRestored: {// 恢复交易
                [self.paymentQueue finishTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateDeferred: {// 队列中的交易，等待外部操作，例如购买请求
            }
                break;
        }
    }
}


#pragma mark - Private
- (void)mp_requestComplete:(MAGIAPState)state tips:(nullable NSString *)tips {
    if ([self.delegate respondsToSelector:@selector(transcationStatus:state:tips:)]) {
        [self.delegate transcationStatus:self state:state tips:tips];
    }
}


#pragma mark - Getter/Setter
- (NSMutableDictionary *)productCache {
    if (_productCache == nil) {
        _productCache = [NSMutableDictionary dictionary];
    }
    return _productCache;
}

- (SKPaymentQueue *)paymentQueue {
    return [SKPaymentQueue defaultQueue];
}

- (NSMutableArray<id<SKPaymentTransactionObserver>> *)transactionObserverArray {
    if (_transactionObserverArray == nil) {
        _transactionObserverArray = [NSMutableArray array];
    }
    return _transactionObserverArray;
}

+ (NSArray<NSString *> *)fixedGoodsIdentifier {
    static NSArray<NSString *> *_identifiers;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _identifiers = @[@"M_MONEY_1", @"M_MONEY_2", @"M_MONEY_3"];
    });
    return _identifiers;
}

@end

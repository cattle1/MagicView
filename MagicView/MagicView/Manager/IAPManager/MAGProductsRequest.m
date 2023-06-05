//
//  MAGProductsRequest.m
//  MagicView
//
//  Created by LL on 2021/10/19.
//

#import "MAGProductsRequest.h"

@interface MAGProductsRequest ()<SKProductsRequestDelegate>

@property (nonatomic, copy) void (^requestComplete)(SKProductsResponse *response);

@end

@implementation MAGProductsRequest

static NSMutableSet<MAGProductsRequest *> *_requests;
+ (void)initialize {
    _requests = [NSMutableSet set];
}

+ (void)requestProductsWithIdentifiers:(NSArray<NSString *> *)identifiers complete:(void (^)(SKProductsResponse *response))complete {
    MAGProductsRequest *productsRequest = [[self alloc] initWithProductIdentifiers:[NSSet setWithArray:identifiers]];
    productsRequest.delegate = productsRequest;
    productsRequest.requestComplete = complete;
    [productsRequest start];
    [_requests addObject:productsRequest];
}


#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    !self.requestComplete ?: self.requestComplete(response);
    [_requests removeObject:self];
}

@end

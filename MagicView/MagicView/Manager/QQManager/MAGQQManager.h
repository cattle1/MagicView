//
//  MAGQQManager.h
//  MagicView
//
//  Created by LL on 2021/10/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAGQQManager : NSObject

+ (void)requestLogin:(void (^)(BOOL result))complete;

@end

NS_ASSUME_NONNULL_END

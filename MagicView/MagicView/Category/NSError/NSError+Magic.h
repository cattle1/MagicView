//
//  NSError+Magic.h
//  MagicView
//
//  Created by LL on 2021/8/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (Magic)

+ (NSError *)m_errorWithDescription:(NSString *)description;

@end

NS_ASSUME_NONNULL_END

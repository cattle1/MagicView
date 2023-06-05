//
//  NSError+Magic.m
//  MagicView
//
//  Created by LL on 2021/8/28.
//

#import "NSError+Magic.h"

#import "MAGImport.h"

@implementation NSError (Magic)

+ (NSError *)m_errorWithDescription:(NSString *)description {
    if (mObjectIsEmpty(description)) return [[NSError alloc] init];
    
    return [NSError errorWithDomain:NSCocoaErrorDomain code:-2000 userInfo:@{@"description" : description}];
}

@end

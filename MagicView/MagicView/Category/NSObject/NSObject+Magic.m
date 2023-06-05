//
//  NSObject+Magic.m
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import "NSObject+Magic.h"

#import "MAGImport.h"

@implementation NSObject (Magic)

- (BOOL)m_writeToFile:(NSString *)path {
    if (mObjectIsEmpty(path) || [path isEqualToString:@"/"]) return NO;
    
    /// 判断路径下的文件夹是否存在，如果不存在则自动创建
    NSString *rootPath = path.stringByDeletingLastPathComponent;
    if (![mFileManager fileExistsAtPath:rootPath]) {
        [mFileManager createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if ([self isKindOfClass:NSData.class]) {
        return [self mp_writeToFile:path data:(NSData *)self];
    }
    
    if ([self isKindOfClass:NSDictionary.class] ||
        [self isKindOfClass:NSArray.class] ||
        [self isKindOfClass:NSSet.class]) {
        return [self mp_writeToFile:path data:[self modelToJSONData]];
    }
    
    if ([self isKindOfClass:NSString.class]) {
        return [self mp_writeToFile:path data:[(NSString *)self dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSDictionary *t_dict = [self modelToJSONObject];
    if ([t_dict isKindOfClass:NSDictionary.class]) {
        return [self mp_writeToFile:path data:[self modelToJSONData]];;
    }
    
    return NO;
}

- (void)m_addNotificationWithName:(nullable NSNotificationName)aName selector:(SEL)aSelector {
    [self m_addNotificationWithName:aName selector:aSelector object:nil];
}

- (void)m_addNotificationWithName:(nullable NSNotificationName)aName selector:(SEL)aSelector object:(nullable id)anObject {
    [NSNotificationCenter.defaultCenter addObserver:self selector:aSelector name:aName object:anObject];
}

+ (void)m_addNotificationWithName:(nullable NSNotificationName)aName selector:(SEL)aSelector {
    [self m_addNotificationWithName:aName selector:aSelector object:nil];
}

+ (void)m_addNotificationWithName:(nullable NSNotificationName)aName selector:(SEL)aSelector object:(nullable id)anObject {
    [NSNotificationCenter.defaultCenter addObserver:self selector:aSelector name:aName object:anObject];
}


#pragma mark - Private
- (BOOL)mp_writeToFile:(NSString *)path data:(NSData *)data {
    if (mObjectIsEmpty(data)) return NO;
    if (mObjectIsEmpty(path)) return NO;
    
    return [data.m_encryptAES writeToFile:path atomically:YES];
}

@end

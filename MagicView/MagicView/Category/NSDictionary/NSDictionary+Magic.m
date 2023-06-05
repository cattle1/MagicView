//
//  NSDictionary+Magic.m
//  MagicView
//
//  Created by LL on 2021/8/20.
//

#import "NSDictionary+Magic.h"

#import "MAGImport.h"

@implementation NSDictionary (Magic)

- (NSString *)m_serverSignString {
    if (mObjectIsEmpty(self)) return @"";
    
    NSArray *allKeys = [self.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];;
    }];
    
    NSMutableString *signString = [NSMutableString stringWithString:app_key];
    for (NSString *key in allKeys) {
        [signString appendFormat:@"%@=%@&", key, self[key]];
    }
    [signString m_deletingLastChar];
    [signString appendString:secret_key];
    
    return signString.md5String ?: @"";
}

+ (nullable NSDictionary *)m_dictionaryWithContentsOfFile:(NSString *)path {
    if (mObjectIsEmpty(path)) return nil;
    if (![mFileManager fileExistsAtPath:path]) return nil;
    
    NSData *decryptData = [NSData m_dataWithContentsOfFile:path];
    return decryptData.m_toDictionary;
}

+ (NSDictionary *)m_dictionaryWithServerData:(id)origin {
    if (![origin isKindOfClass:NSData.class]) return nil;
    
    NSData *decryptData = [(NSData *)origin m_serverDecrypt];    
    return decryptData.m_toDictionary;;
}

@end


@implementation NSMutableDictionary (Magic)

+ (nullable NSMutableDictionary *)m_dictionaryWithContentsOfFile:(NSString *)path {
    return [[NSDictionary m_dictionaryWithContentsOfFile:path] mutableCopy];
}

@end

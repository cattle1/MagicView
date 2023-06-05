//
//  NSData+Magic.m
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import "NSData+Magic.h"

#import "MAGImport.h"

@implementation NSData (Magic)

#pragma mark - Public
- (NSData *)m_serverDecrypt {
    NSString *string = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    NSData *originData = [[NSData alloc] initWithBase64EncodedString:string options:0];
    
    return [originData aes256DecryptWithkey:kEncryptionKey.dataValue iv:kEncryptionSecret.dataValue];
}

- (NSData *)m_encryptAES {
    if (mIOEncryptionSwitch) return [self aes256EncryptWithKey:mAESKey.dataValue iv:nil];
    return self;
}

- (NSData *)m_decryptAES {
    if (mIOEncryptionSwitch) return [self aes256DecryptWithkey:mAESKey.dataValue iv:nil];
    return self;
}

- (NSDictionary *)m_toDictionary {
    if (self.length == 0) return nil;
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:self options:0 error:NULL];
    
    if ([jsonObj isKindOfClass:NSDictionary.class]) return (NSDictionary *)jsonObj;
    return nil;
}

- (NSArray *)m_toArray {
    if (self.length == 0) return nil;
    
    id obj = [NSJSONSerialization JSONObjectWithData:self options:0 error:NULL];
    
    if ([obj isKindOfClass:NSArray.class]) return (NSArray *)obj;
    return nil;
}

+ (NSData *)m_dataWithContentsOfFile:(NSString *)path {
    if (mObjectIsEmpty(path)) return nil;
    if (![mFileManager fileExistsAtPath:path]) return nil;
    
    NSData *originData = [[NSData alloc] initWithContentsOfFile:path];
    if (mObjectIsEmpty(originData)) return nil;
    
    if (mIOEncryptionSwitch) return originData.m_decryptAES;
    return originData;
}

@end


@implementation NSMutableData (Magic)

+ (nullable NSData *)m_dataWithContentsOfFile:(NSString *)path {
    return [[NSData m_dataWithContentsOfFile:path] mutableCopy];
}

@end

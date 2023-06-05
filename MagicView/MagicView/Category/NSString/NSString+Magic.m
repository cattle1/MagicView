//
//  NSString+Magic.m
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import "NSString+Magic.h"

#import "MAGImport.h"

@implementation NSString (Magic)

- (NSString *)m_chineseURL {
    static YYCache *_noChineseCharCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _noChineseCharCache = [YYCache cacheWithName:mNoChineseCharCacheKey];
    });
    
    if ([_noChineseCharCache containsObjectForKey:self]) return (NSString *)[_noChineseCharCache objectForKey:self];
    
    if (self.m_containChinese) {
        NSString *urlString = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [_noChineseCharCache setObject:urlString forKey:self];
        return urlString;
    } else {
        [_noChineseCharCache setObject:self forKey:self];
        return self;
    }
}

- (BOOL)m_containChinese {
    for (int i = 0; i < [self length]; i++) {
        unichar t_char = [self characterAtIndex:i];
        if (t_char >= 0x4E00 && t_char <= 0x9FA5) return YES;
    }
    return NO;
}

- (NSString *)m_localiedString {
    return self;
}

- (BOOL)m_isFolder {
    BOOL isDir = NO;
    [mFileManager fileExistsAtPath:self isDirectory:&isDir];
    return isDir;
}

- (NSURL *)m_URL {
    return [NSURL URLWithString:self];
}

- (NSURL *)m_fileURL {
    return [NSURL fileURLWithPath:self];
}

- (NSString *)m_bundlePath {
    return [NSBundle.mainBundle pathForResource:self ofType:nil];
}

+ (nullable NSString *)m_stringWithContentsOfFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)error {
    if (mObjectIsEmpty(path)) return nil;
    if (![mFileManager fileExistsAtPath:path]) return nil;
    
    NSData *decryptData = [NSData m_dataWithContentsOfFile:path];
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}

+ (nullable NSString *)m_errorMessageFromCode:(NSInteger)code {
    NSDictionary *errorDictionary = [self m_errorDictionary];
    NSString *message = errorDictionary[mNSStringFromInteger(code)];
    if (message) return message;
    return nil;
}

- (CGFloat)m_fileSize {
    BOOL isDir = NO;
    CGFloat total = 0;
    BOOL isExists = [mFileManager fileExistsAtPath:self isDirectory:&isDir];
    // 是文件夹
    if (isExists && isDir) {
        NSArray *array = [mFileManager contentsOfDirectoryAtPath:self error:nil];
        for (NSString *subPath in array) {
            NSString *fullPath = [self stringByAppendingPathComponent:subPath];
            if (fullPath.m_isFolder) {
                total += fullPath.m_fileSize;
            } else {
                total += fullPath.mp_fileSize;
            }
        }
    }
    
    // 是文件
    if (isExists && !isDir) {
        total = self.mp_fileSize;
    }
    
    return total;
}

+ (NSString *)m_UUIDString {
    NSString *UUIDString = [mUserDefault objectForKey:mUUIDKey];
    
    if (mObjectIsEmpty(UUIDString)) {
        // 从本地获取UUID
        UUIDString = [YYKeychain getPasswordForService:mUUIDKey account:mUUIDKey];
        if (!mObjectIsEmpty(UUIDString)) {
            [mUserDefault setObject:UUIDString forKey:mUUIDKey];
        }
    }
    
    if (mObjectIsEmpty(UUIDString)) {
        // 生成UUID
        UUIDString = [NSString stringWithUUID];
        
        [YYKeychain setPassword:UUIDString forService:mUUIDKey account:mUUIDKey];
        [mUserDefault setObject:UUIDString forKey:mUUIDKey];
    }
    
    return UUIDString;
}

- (NSString *)m_optionalEncryption {
    if (mIOEncryptionSwitch) return self.md5String;
    return self;
}

+ (NSString *)m_randomChinese {
    return [self m_createRandomChineseWithNum:1];
}

+ (NSString *)m_randomChar {
    return [self m_createRandomWordWithNum:1];
}

+ (NSString *)m_createRandomChineseWithNum:(NSUInteger)num {
    NSInteger _num = (NSInteger)num;
    if (_num <= 0) return @"";
    
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSMutableString *string = [NSMutableString string];
    
    do {
        NSInteger randomH = 0xA1 + arc4random() % (0xFE - 0xA1+1);
        NSInteger randomL = 0xB0 + arc4random() % (0xF7 - 0xB0+1);
        NSInteger number = (randomH<<8) + randomL;
        NSData *data = [NSData dataWithBytes:&number length:2];
        [string appendString:[[NSString alloc] initWithData:data encoding:gbkEncoding]];
        _num -= 1;
    } while (_num > 0);

    return [string copy];
}

+ (NSString *)m_createRandomWordWithNum:(NSUInteger)num {
    NSInteger _num = (NSInteger)num;
    if (_num <= 0) return @"";
    
    NSMutableString *string = [NSMutableString string];
    
    do {
        int figure = (arc4random() % 26) + 97;
        char character = figure;
        [string appendString:[NSString stringWithFormat:@"%c", character]];
        _num -= 1;
    } while (_num > 0);

    return [string copy];
}

+ (NSString *)m_createRandomStringWithNum:(NSUInteger)num {
    NSInteger _num = (NSInteger)num;
    if (_num <= 0) return @"";
    
    NSMutableString *string = [NSMutableString string];
    
    for (NSInteger i = 0; i < num; i++) {
        NSInteger random = mRandomInteger(1, 5);
        if (random < 4) {
            [string appendString:[NSString stringWithFormat:@"%zd", mRandomInteger(0, 9)]];
        } else {
            [string appendString:[self m_randomChar]];
        }
    }
    
    return [string copy];
}

- (nullable NSString *)m_substringToString:(NSString *)string {
    return [self m_substringToString:string isContain:NO];
}

- (nullable NSString *)m_substringToString:(NSString *)string isContain:(BOOL)isContain {
    if (![self containsString:string]) return nil;
    
    NSRange range = [self rangeOfString:string];
    NSString *t_string = [self substringToIndex:range.location];
    if (isContain) {
        t_string = [t_string stringByAppendingString:string];
    }
    return t_string;
}

- (nullable NSString *)m_substringFromString:(NSString *)string {
    return [self m_substringFromString:string isContain:NO];
}

- (nullable NSString *)m_substringFromString:(NSString *)string isContain:(BOOL)isContain {
    if (![self containsString:string]) return nil;
    
    NSRange range = [self rangeOfString:string];
    NSString *t_string = [self substringFromIndex:range.location + range.length];
    if (isContain) {
        t_string = [string stringByAppendingString:t_string];
    }
    return t_string;
}


#pragma mark - Private
- (CGFloat)mp_fileSize {
    if (![mFileManager fileExistsAtPath:self]) return 0;
    
    return [[mFileManager attributesOfItemAtPath:self error:nil] fileSize];
}

#pragma mark - Getter
+ (NSDictionary *)m_errorDictionary {
    static NSDictionary *_errorDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _errorDictionary = @{
            @"-1"    : @"Invalid URL address",
            @"-999"  : @"Invalid URL address",
            @"-1000" : @"Invalid URL address",
            @"-1001" : @"Network connection timeout",
            @"-1002" : @"Unsupported URL Address",
            @"-1003" : @"Unable to find server",
            @"-1004" : @"Unable to connect to server",
            @"-1005" : @"Abnormal network connection",
            @"-1006" : @"DNS query failed",
            @"-1007" : @"HTTP request redirection",
            @"-1008" : @"Resource Unavailable",
            @"-1009" : @"There is currently no network connection",
            @"-1010" : @"Redirect to a non-existent location",
            @"-1011" : @"Server response exception",
            @"-1012" : @"User cancels authorization",
            @"-1013" : @"User authorization required",
            @"-1014" : @"0 Byte Resource",
            @"-1015" : @"Unable to decode raw data",
            @"-1016" : @"Unable to decode content data",
            @"-1017" : @"Unable to parse response",
            @"-1018" : @"International roaming disabled",
            @"-1019" : @"Called activation",
            @"-1020" : @"Data not allowed",
            @"-1100" : @"file does not exist",
            @"-1101" : @"The file is a directory",
            @"-1102" : @"No Read File Permissions",
            @"-1103" : @"Request data length exceeds maximum limit",
            @"-1200" : @"Secure connection failure",
            @"-1201" : @"Server certificate expiration",
            @"-1202" : @"Untrusted server certificate",
            @"-1203" : @"Unknown Root Server Certificate",
            @"-1204" : @"The server certificate is not valid",
            @"-1205" : @"Client certificate rejected",
            @"-1206" : @"Require client certificate",
            @"-2000" : @"Unable to obtain from the network",
            @"-3000" : @"could not create file",
            @"-3001" : @"could not open file",
            @"-3002" : @"cannot close file",
            @"-3003" : @"Unable to write to file",
            @"-3004" : @"cannot delete file",
            @"-3005" : @"Unable to move file",
            @"-3006" : @"Failed to download decoding data",
            @"-3007" : @"Failed to download decoding data",
        };
    });
    return _errorDictionary;
}

@end




@implementation NSMutableString (Magic)

- (nullable NSString *)m_deletingLastChar {
    if (self.length == 0) return nil;
    
    NSRange lastRange = NSMakeRange(self.length - 1, 1);
    NSString *lastString = [self substringWithRange:lastRange];
    [self deleteCharactersInRange:lastRange];
    
    return lastString;
}

+ (nullable NSMutableString *)m_stringWithContentsOfFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)error {
    return [[NSString m_stringWithContentsOfFile:path encoding:enc error:error] mutableCopy];
}

@end

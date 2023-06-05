//
//  NSString+Magic.h
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import <Foundation/Foundation.h>

#import "MAGEnumDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Magic)

/// 如果字符串中包含汉字，则将其转为符合URL标准的字符串
@property (nonatomic, readonly) NSString *m_chineseURL;

/// 如果字符串包含汉字则返回YES，否则返回NO
@property (nonatomic, readonly) BOOL m_containChinese;

/// 返回当前语言环境下的翻译文案
@property (nonatomic, readonly) NSString *m_localiedString;

/// 如果路径是一个文件夹则返回YES，否则返回NO
@property (nonatomic, readonly) BOOL m_isFolder;

@property (nonatomic, readonly) NSURL *m_URL;

@property (nonatomic, readonly) NSURL *m_fileURL;

/// 返回指定名称资源的完整路径
/// @discussion 和[NSBundle.mainBundle pathForResource:self ofType:nil]; 作用一样
@property (nonatomic, readonly) NSString *m_bundlePath;

/// 如果开启了IO加密则返回加密内容，否则返回原内容
@property (nonatomic, readonly) NSString *m_optionalEncryption;

/// 返回指定路径下文件/文件夹的大小
@property (nonatomic, readonly) CGFloat m_fileSize;

/// 根据路径获取加密数据，并转换为 NSString 对象返回。
/// @discussion 如果存储时不是通过加密方式存储则不要使用该方法获取数据。
+ (nullable NSString *)m_stringWithContentsOfFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)error;

/// 根据 code码返回错误提示字符串
+ (nullable NSString *)m_errorMessageFromCode:(NSInteger)code;

+ (NSString *)m_UUIDString;

/// 随机生成一个汉字并返回
+ (NSString *)m_randomChinese;

/// 随机生成一个小写字母并返回
+ (NSString *)m_randomChar;

/// 随机生成指定数量汉字并返回
+ (NSString *)m_createRandomChineseWithNum:(NSUInteger)num;

/// 随机生成指定数量小写字母并返回
+ (NSString *)m_createRandomWordWithNum:(NSUInteger)num;

/// 随机生成指定数量的字母加数字并返回
+ (NSString *)m_createRandomStringWithNum:(NSUInteger)num;

/// 返回一个新的字符串，包含直到第一个接收者的内容，但不包括该字符
/// @code
/// [@"info?goods_id=xxx" m_substringToString:@"?"] => @"info"
/// @endcode
- (nullable NSString *)m_substringToString:(NSString *)string;

/// 返回一个新的字符串，包含直到/不直到第一个接收者的内容，由 isContain 决定是否包含
/// @code
/// [@"info?goods_id=xxx" m_substringToString:@"?" isContain:YES] => @"info?"
/// [@"info?goods_id=xxx" m_substringToString:@"?" isContain:NO] => @"info"
/// @endcode
- (nullable NSString *)m_substringToString:(NSString *)string isContain:(BOOL)isContain;

/// 返回一个新的字符串，包含第一个接收者直到末尾的内容，但不包括该字符
/// @code
/// [@"info?goods_id=xxx" m_substringFromString:@"?"] => @"goods_id=xxx"
/// @endcode
- (nullable NSString *)m_substringFromString:(NSString *)string;

/// 返回一个新的字符串，包含/不包含第一个接收者直到末尾的内容，由 isContain 决定是否包含
/// @code
/// [@"info?goods_id=xxx" m_substringFromString:@"?" isContain:YES] => @"?goods_id=xxx"
/// [@"info?goods_id=xxx" m_substringFromString:@"?" isContain:NO] => @"goods_id=xxx"
/// @endcode
- (nullable NSString *)m_substringFromString:(NSString *)string isContain:(BOOL)isContain;

@end



@interface NSMutableString (Magic)

/// 删除字符串的最后一个字符，如果删除成功则返回那个字符，否则返回nil
- (nullable NSString *)m_deletingLastChar;

/// 根据路径获取加密数据，并转换为 NSMutableString 对象返回。
/// @discussion 如果存储时不是通过加密方式存储则不要使用该方法获取数据。
+ (nullable NSMutableString *)m_stringWithContentsOfFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END

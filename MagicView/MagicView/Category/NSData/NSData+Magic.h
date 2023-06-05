//
//  NSData+Magic.h
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Magic)

/// 解密并返回服务端的数据
@property (nonatomic, readonly, nullable) NSData *m_serverDecrypt;

/// 使用默认 key 进行 AES加密并返回加密后的数据
@property (nonatomic, readonly, nullable) NSData *m_encryptAES;

/// 使用默认 key进行 AES解密并返回解密后的数据
@property (nonatomic, readonly, nullable) NSData *m_decryptAES;

@property (nonatomic, readonly, nullable) NSDictionary *m_toDictionary;

@property (nonatomic, readonly, nullable) NSArray *m_toArray;


/// 使用指定路径下的字节数据创建一个 Data 并返回
/// @discussion 仅限于获取壳内的文件数据
+ (nullable NSData *)m_dataWithContentsOfFile:(NSString *)path;

@end


@interface NSMutableData (Magic)

/// 使用指定路径下的字节数据创建一个 NSMutableData 并返回
/// @discussion 仅限于获取壳内的文件数据
+ (nullable NSData *)m_dataWithContentsOfFile:(NSString *)path;

@end

NS_ASSUME_NONNULL_END

//
//  NSDictionary+Magic.h
//  MagicView
//
//  Created by LL on 2021/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Magic)

/// 返回接口请求数据签名后的字符串
@property (nonatomic, readonly) NSString *m_serverSignString;


/// 使用指定路径下的字节数据创建一个字典并返回
/// @discussion 仅限于获取壳内的文件数据
+ (nullable NSDictionary *)m_dictionaryWithContentsOfFile:(NSString *)path;

/// 将服务端的加密数据解密并转换为字典然后返回
+ (nullable NSDictionary *)m_dictionaryWithServerData:(id)origin;

@end


@interface NSMutableDictionary (Magic)

/// 使用指定路径下的字节数据创建一个字典并返回
/// @discussion 仅限于获取壳内的文件数据
+ (nullable NSMutableDictionary *)m_dictionaryWithContentsOfFile:(NSString *)path;

@end

NS_ASSUME_NONNULL_END

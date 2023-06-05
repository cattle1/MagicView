//
//  NSArray+Magic.h
//  MagicView
//
//  Created by LL on 2021/8/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Magic)

/// 使用指定路径下的字节数据创建一个数组并返回
/// @discussion 仅限于获取壳内的文件数据
+ (nullable NSArray *)m_arrayWithContentsOfFile:(NSString *)path;

/// 获取小说分类类型
+ (NSArray<NSString *> *)m_categoryArray;

/// 返回一个顺序不同但内容和原数组相同的新数组
- (NSArray *)m_randomArray;

@end


@interface NSMutableArray (Magic)

/// 使用指定路径下的字节数据创建一个可变数组并返回
/// @discussion 仅限于获取壳内的文件数据
+ (nullable NSMutableArray *)m_arrayWithContentsOfFile:(NSString *)path;

@end

NS_ASSUME_NONNULL_END

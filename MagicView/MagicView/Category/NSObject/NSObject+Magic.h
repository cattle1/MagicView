//
//  NSObject+Magic.h
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Magic)

/// 将数据对象的字节写入到给定路径的文件
/// @discussion 使用该方法保存数据的好处如下：
///
/// 1. 自动创建路径上不存在的文件夹
///
/// 2. 数据自动加密
///
/// 3. 支持Model对象
/// @note NSDictionary、NSString、NSArray都会转为NSData并加密保存
- (BOOL)m_writeToFile:(NSString *)path;

- (void)m_addNotificationWithName:(nullable NSNotificationName)aName selector:(SEL)aSelector;

- (void)m_addNotificationWithName:(nullable NSNotificationName)aName selector:(SEL)aSelector object:(nullable id)anObject;

+ (void)m_addNotificationWithName:(nullable NSNotificationName)aName selector:(SEL)aSelector;

+ (void)m_addNotificationWithName:(nullable NSNotificationName)aName selector:(SEL)aSelector object:(nullable id)anObject;

@end

NS_ASSUME_NONNULL_END

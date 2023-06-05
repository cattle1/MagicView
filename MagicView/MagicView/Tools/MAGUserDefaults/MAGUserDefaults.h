//
//  MAGUserDefaults.h
//  iOSTE
//
//  Created by LL on 2021/9/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 和 NSUserDefaults 作用类似，用于保存 Magic 内部的数据，所有API均是线程安全的
@interface MAGUserDefaults : NSObject

+ (nullable id)objectForKey:(NSString *)key;

+ (void)setObject:(id _Nullable)object forKey:(NSString *)key;

/// 立即写入本地
+ (void)prompt_setObject:(id _Nullable)object forKey:(NSString *)key;

+ (BOOL)boolForKey:(NSString *)key;

+ (void)setBool:(BOOL)boolObj forKey:(NSString *)key;

+ (NSInteger)integerForKey:(NSString *)key;

+ (void)setInteger:(NSInteger)integerObj forKey:(NSString *)key;

+ (CGFloat)floatForKey:(NSString *)key;

+ (void)setFloat:(CGFloat)floatObj forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

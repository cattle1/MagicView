//
//  MAGClickAgent.h
//  MagicView
//
//  Created by LL on 2021/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAGClickAgent : NSObject

+ (void)event:(NSString *)eventName;

+ (void)event:(NSString *)eventName attributes:(nullable NSDictionary *)attributes;


/// 将视图控制器名称添加到已显示列表
+ (void)appendDidAppearViewControllerName:(NSString *)aName;

/// 获取所有已显示的视图控制器名称，最新显示的控制器名称在第一位
+ (NSArray<NSString *> *)didAppearViewControllerArray;

/// 获取最近显示的视图控制器的名称
+ (nullable NSString *)topViewControllerName;

@end

NS_ASSUME_NONNULL_END

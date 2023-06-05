//
//  UIColor+Magic.h
//  MagicView
//
//  Created by LL on 2021/9/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 渐变色方向
typedef NS_ENUM(NSInteger, MGradientChangeDirection) {
    /// 水平方向上渐变
    MGradientChangeDirectionLevel              = 0,
    /// 竖直方向上渐变
    MGradientChangeDirectionVertical           = 1,
    /// 向下对角线渐变
    MGradientChangeDirectionUpwardDiagonalLine = 2,
    /// 向上对角线渐变
    MGradientChangeDirectionDownDiagonalLine   = 3,
};

@interface UIColor (Magic)

/// 判断当前颜色是否为深色，可用于根据不同色调动态设置不同文字颜色的场景。
@property (nonatomic, readonly) BOOL m_isDarkColor;

#pragma mark - GradientColor
@property (nonatomic, readonly) BOOL m_isGradientColor;

/// 每个渐变色标颜色的对象数组
@property (nonatomic, copy, nullable) NSArray<UIColor *> *m_gradientColors;

@property (nonatomic, assign) MGradientChangeDirection m_gradientDirection;

/**
 * 一个可选的 NSNumber 对象数组，定义渐变色每个梯度停止的位置，范围是0~1
 *
 * 关于更详细的信息可查看 CAGradientLayer 的属性 locations
 */
@property (nonatomic, copy, nullable) NSArray<NSNumber *> *m_locations;

/**
 * 创建并返回一个水平方向均匀分布的延迟渐变色对象
 *
 * 有关更详细的描述请参考 m_gradientColorWithDirection: colorArray: locations: 方法
 */
+ (nullable UIColor *)m_delayGradientColorWithColorArray:(NSArray<UIColor *> *)colorArray;

/**
 * 创建并返回一个延迟渐变色对象
 *
 * 该方法并不会真的生成一个渐变色对象，渐变色对象将会被延迟到覆值时创建
 *
 * 建议都使用该方法或基于该方法创建渐变色， 因为这样做使用者无需关心 size
 *
 * 目前只适配了 MAGView 的 backgroundColor 属性
 *
 * @param direction 渐变方向
 * @param colorArray 定义每个渐变色标颜色的对象数组
 * @param locations 一个可选的 NSNumber 对象数组，定义每个梯度停止的位置
 */
+ (nullable UIColor *)m_delayGradientColorWithDirection:(MGradientChangeDirection)direction
                                        colorArray:(NSArray<UIColor *> *)colorArray
                                         locations:(NSArray<NSNumber *> *_Nullable)locations;

/// 使用延迟渐变色对象和 size 创建一个渐变色对象
/// @param colorSize 渐变色的 size
/// @param delayGradientColor 延迟渐变色对象
+ (nullable UIColor *)m_createGradientColorWithSize:(CGSize)colorSize delayGradientColor:(UIColor *)delayGradientColor;

/// 创建并返回一个渐变色对象
/// @param direction 渐变方向
/// @param colorSize 渐变色的 size
/// @param colorArray 定义每个渐变色标颜色的对象数组
/// @param locations 一个可选的 NSNumber 对象数组，定义每个梯度停止的位置
+ (nullable UIColor *)m_createGradientColorWithDirection:(MGradientChangeDirection)direction
                                               colorSize:(CGSize)colorSize
                                              colorArray:(NSArray<UIColor *> *)colorArray
                                                location:(NSArray<NSNumber *> *_Nullable)locations;

@end

NS_ASSUME_NONNULL_END

//
//  LLActivityIndicator.h
//  iOSHelper
//
//  Created by Chair on 2020/4/1.
//  Copyright © 2020 Chair. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 指示器样式
typedef NS_ENUM(NSUInteger, MActivityIndicatorViewStyle) {
    MActivityIndicatorViewStyleWhiteMedium = 0,/**<小型白色指示器*/
    MActivityIndicatorViewStyleGrayMedium  = 1,/**<小型黑色指示器*/
    MActivityIndicatorViewStyleWhiteLarge  = 2,/**<大型白色指示器*/
    MActivityIndicatorViewStyleGrayLarge   = 3 /**<大型黑色指示器*/
};

/**
* @brief UIActivityIndicatorView增强版
* @discussion 1. 除了可以自定义颜色之外，还可以自定义指示器的详细大小(例如指示器宽度、高度、离心距离等)。
* @discussion 2. 内部会自动计算控件所需要的最小宽高，可以不设置宽高约束或宽高Frame。
* @discussion 3. 可以暂停/恢复指示器动画。
*/
@interface MAGActivityIndicatorView : UIView

/**
* @brief 一个枚举，用于控制指示器样式。
* @discussion 可以通过其他属性覆盖枚举样式(例如width、color、height)。
*/
@property (nonatomic, assign) MActivityIndicatorViewStyle style;

/**
* @brief 一个颜色值，用于控制指示器的颜色(修改立即生效)。
* @discussion 该值会覆盖LLActivityIndicatorViewStyle的色值，设置nil代表使用默认值(白色)。
*/
@property (nonatomic, strong, nullable) UIColor *color;

/**
* @brief 一个浮点数，用于控制指示器的离心距离(修改立即生效)。
* @discussion 该值表示指示器的末端距离中心点的距离，默认值是5.0f。
* @discussion 如果高度加上离心距离大于UIView显示区域，内部会减少相对应的离心距离已适应UIView。
*/
@property (nonatomic, assign) CGFloat gap;

/**
* @brief 一个无符号整数，用于控制指示器的显示数量(修改立即生效)。
* @discussion 数值必须大于1，默认值是12。
*/
@property (nonatomic, assign) NSUInteger number;

/**
* @brief 一个浮点数，用于控制指示器的宽度(修改立即生效)。
* @discussion 浮点数必须大于0.0f，默认值是2.5f。
*/
@property (nonatomic, assign) CGFloat width;

/**
* @brief 一个浮点数，用于控制指示器的长度(修改立即生效)。
* @discussion 浮点数必须大于0.0，默认值是5.0f。
* @discussion 如果高度加上离心距离大于UIView显示区域，内部会减少相对应的离心距离已适应UIView。
*/
@property (nonatomic, assign) CGFloat height;

/**
* @brief 一个浮点数，用于控制指示器的圆角(修改立即生效)。
* @discussion 可以将指示器设置成圆形或椭圆形等类圆图形，此属性默认为(width × 0.5)。
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
* @brief 一个时间值，用于控制动画时长(修改立即生效)。
* @discussion 默认值是1.0秒，注意：修改后动画会重新开始。
 */
@property (nonatomic, assign) NSTimeInterval duration;


+ (instancetype)activityIndicatorWithStyle:(MActivityIndicatorViewStyle)style;

+ (instancetype)activityIndicatorWithColor:(UIColor * _Nullable)color;

+ (instancetype)activityIndicatorWithColor:(UIColor * _Nullable)color gap:(CGFloat)gap number:(NSUInteger)number width:(CGFloat)width height:(CGFloat)height cornerRadius:(CGFloat)cornerRadius duration:(NSTimeInterval)duration;

- (void)startAnimating;

- (void)stopAnimating;

- (void)pauseAnimating;

- (BOOL)isAnimating;

@end

NS_ASSUME_NONNULL_END

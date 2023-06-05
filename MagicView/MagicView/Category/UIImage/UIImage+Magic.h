//
//  UIImage+Magic.h
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Magic)

/// 返回一张`UIImageRenderingModeAutomatic`渲染模式的新图片
@property (nonatomic, readonly) UIImage *m_renderingModeAutomatic;

/// 返回一张`UIImageRenderingModeAlwaysOriginal`渲染模式的新图片
@property (nonatomic, readonly) UIImage *m_renderingModeAlwaysOriginal;

/// 返回一张`UIImageRenderingModeAlwaysTemplate`渲染模式的新图片
@property (nonatomic, readonly) UIImage *m_renderingModeAlwaysTemplate;

/// 使用指定的图像创建颜色对象
/// 有关更详细的说明请查看 UIColor 的 +colorWithPatternImage: 方法
@property (nonatomic, readonly) UIColor *m_patternColor;

/// 从 YYImageCache 中获取指定 key 的缓存图片，如果没有则返回nil
+ (nullable UIImage *)m_cacheImageForKey:(NSString *)key;

/// 从 YYImageCache 中获取指定 key 的缓存图片数据，如果没有则返回nil
+ (nullable NSData *)m_cacheImageDataForKey:(NSString *)key;

/// 判断 YYImageCache 是否包含指定 key 的缓存图片，如果包含则返回YES，否则返回NO
+ (BOOL)m_containCacheImageForKey:(NSString *)key;


/// 创建一个100×100像素的昵称头像图片
+ (UIImage *)m_acquireNameImageWithName:(NSString *)string;

/// 根据昵称创建图像
/// @param nameString 昵称建议不要超过2个字符
/// @param imageSize 图片大小
/// @param imageColor 图片的颜色，默认是随机色
/// @param nameFont 昵称的字体，默认是[UIFont systemFontOfSize:14.0]
/// @param textColor 昵称颜色，默认是黑色或白色
+ (UIImage *)m_acquireNameImageWithName:(NSString *)nameString
                              imageSize:(CGSize)imageSize
                             imageColor:(nullable UIColor *)imageColor
                               nameFont:(nullable UIFont *)nameFont
                              textColor:(nullable UIColor *)textColor;


/// 创建一个包含系统符号图像的图像对象
/// @discussion 如果图片不存在或者系统版本低于13.0，那么返回默认占位图
/// @param name 系统符号图像的名称，使用 SF Symbols 应用程序查找系统符号图像的名称，https://developer.apple.com/sf-symbols/
+ (nullable UIImage *)m_systemImageNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END

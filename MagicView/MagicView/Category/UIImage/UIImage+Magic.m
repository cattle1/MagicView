//
//  UIImage+Magic.m
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import "UIImage+Magic.h"

#import "MAGImport.h"

@implementation UIImage (Magic)

- (UIImage *)m_renderingModeAutomatic {
    return [self imageWithRenderingMode:UIImageRenderingModeAutomatic];
}

-(UIImage *)m_renderingModeAlwaysOriginal {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)m_renderingModeAlwaysTemplate {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (UIColor *)m_patternColor {
    return [UIColor colorWithPatternImage:self];
}

+ (nullable UIImage *)m_cacheImageForKey:(NSString *)key {
    return [YYImageCache.sharedCache getImageForKey:key];
}

+ (nullable NSData *)m_cacheImageDataForKey:(NSString *)key {
    return [YYImageCache.sharedCache getImageDataForKey:key];
}

+ (BOOL)m_containCacheImageForKey:(NSString *)key {
    return ([self m_cacheImageForKey:key] != nil);
}

+ (UIImage *)m_acquireNameImageWithName:(NSString *)string {
    NSArray *colorArray = @[mColorRGB(23, 194, 148), mColorRGB(179, 137, 121), mColorRGB(242, 114, 94), mColorRGB(247, 181, 94), mColorRGB(77, 169, 235), mColorRGB(95, 112, 167), mColorRGB(86, 138, 173), mColorRGB(30, 144, 255), mColorRGB(70, 130, 180), mColorRGB(255, 140, 0), mColorRGB(210, 105, 30)];
    return [self m_acquireNameImageWithName:string imageSize:CGSizeMake(100.0, 100.0) imageColor:colorArray.randomObject nameFont:nil textColor:UIColor.whiteColor];
}

+ (UIImage *)m_acquireNameImageWithName:(NSString *)nameString
                              imageSize:(CGSize)imageSize
                             imageColor:(nullable UIColor *)imageColor
                               nameFont:(nullable UIFont *)nameFont
                              textColor:(nullable UIColor *)textColor {
    if (imageColor == nil) {
        imageColor = mRandomColor;
    }
    
    if (nameFont == nil) {
        nameFont = [UIFont systemFontOfSize:14.0];
    }
    
    if (textColor == nil) {
        textColor = imageColor.m_isDarkColor ? UIColor.whiteColor : UIColor.blackColor;
    }
    
    UIImage *backgroundImage = [UIImage imageWithColor:imageColor size:imageSize];
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [backgroundImage drawAtPoint:CGPointZero];
    
    CGContextRef context= UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathStroke);
    
    // 画名字
    CGSize nameSize = [nameString sizeForFont:nameFont size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) mode:kNilOptions];
    [nameString drawAtPoint:CGPointMake((imageSize.width - nameSize.width) / 2.0, (imageSize.height - nameSize.height) / 2.0) withAttributes:@{NSFontAttributeName : nameFont, NSForegroundColorAttributeName : textColor}];
    
    // 返回绘制的新图形
    UIImage *nameImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return nameImage;
}

+ (nullable UIImage *)m_systemImageNamed:(NSString *)name {
    if (@available(iOS 13.0, *)) {
        UIImage *image = [UIImage systemImageNamed:name];
        return image ? image : mPlaceholdImage;
    } else {
        return mPlaceholdImage;
    }
}

@end

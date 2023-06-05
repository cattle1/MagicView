//
//  UIColor+Magic.m
//  MagicView
//
//  Created by LL on 2021/9/11.
//

#import "UIColor+Magic.h"

#import "MAGImport.h"

@implementation UIColor (Magic)

- (BOOL)m_isDarkColor {
    CGFloat red = 0.0, green = 0.0, blue = 0.0;
    if ([self getRed:&red green:&green blue:&blue alpha:0]) {
        float referenceValue = 0.411;
        float colorDelta = ((red * 0.299) + (green * 0.587) + (blue * 0.114));

        return 1.0 - colorDelta > referenceValue;
    }
    
    return YES;
}

+ (nullable UIColor *)m_delayGradientColorWithColorArray:(NSArray<UIColor *> *)colorArray {
    return [self m_delayGradientColorWithDirection:MGradientChangeDirectionLevel colorArray:colorArray locations:nil];
}

+ (nullable UIColor *)m_delayGradientColorWithDirection:(MGradientChangeDirection)direction
                                        colorArray:(NSArray<UIColor *> *)colorArray
                                         locations:(NSArray<NSNumber *> *_Nullable)locations {
    UIColor *color = colorArray.firstObject;
    color.m_gradientColors = colorArray;
    color.m_gradientDirection = direction;
    color.m_locations = locations;
    return color;
}

+ (nullable UIColor *)m_createGradientColorWithSize:(CGSize)colorSize delayGradientColor:(UIColor *)delayGradientColor {
    if (!delayGradientColor.m_isGradientColor) return delayGradientColor;
    
    return [self m_createGradientColorWithDirection:delayGradientColor.m_gradientDirection
                                          colorSize:colorSize
                                         colorArray:delayGradientColor.m_gradientColors
                                           location:delayGradientColor.m_locations];
}

+ (nullable UIColor *)m_createGradientColorWithDirection:(MGradientChangeDirection)direction
                                               colorSize:(CGSize)colorSize
                                              colorArray:(NSArray<UIColor *> *)colorArray
                                                location:(NSArray<NSNumber *> *_Nullable)locations {
    if (mObjectIsEmpty(colorArray)) return nil;
    
    if (CGSizeEqualToSize(colorSize, CGSizeZero)) {
        UIColor *color = colorArray.firstObject;
        color.m_gradientColors = colorArray;
        color.m_locations = locations;
        color.m_gradientDirection = direction;
        return color;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = (CGRect){.size = colorSize};

    CGPoint startPoint = CGPointZero;
    if (direction == MGradientChangeDirectionDownDiagonalLine) {
        startPoint = CGPointMake(0.0, 1.0);
    }
    gradientLayer.startPoint = startPoint;
    
    CGPoint endPoint = CGPointZero;
    switch (direction) {
        case MGradientChangeDirectionLevel:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        case MGradientChangeDirectionVertical:
            endPoint = CGPointMake(0.0, 1.0);
            break;
        case MGradientChangeDirectionUpwardDiagonalLine:
            endPoint = CGPointMake(1.0, 1.0);
            break;
        case MGradientChangeDirectionDownDiagonalLine:
            endPoint = CGPointMake(1.0, 0.0);
            break;
    }
    gradientLayer.endPoint = endPoint;
    
    NSMutableArray *t_colorArray = [NSMutableArray array];
    for (UIColor *color in colorArray) {
        [t_colorArray addObject:(id)color.CGColor];
    }
    gradientLayer.colors = [t_colorArray copy];
    
    gradientLayer.locations = locations;
    
    UIGraphicsBeginImageContext(colorSize);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIColor *gradientColor = [UIColor colorWithPatternImage:image];
    gradientColor.m_gradientColors = colorArray;
    gradientColor.m_locations = locations;
    gradientColor.m_gradientDirection = direction;
    
    return gradientColor;
}


#pragma mark - Setter/Getter
- (BOOL)m_isGradientColor {
    return !mObjectIsEmpty(self.m_gradientColors);
}

- (void)setM_gradientColors:(NSArray<UIColor *> *)m_gradientColors {
    [self setAssociateValue:[m_gradientColors copy] withKey:@selector(m_gradientColors)];
}

- (NSArray<UIColor *> *)m_gradientColors {
    return [self getAssociatedValueForKey:@selector(m_gradientColors)];
}

- (void)setM_gradientDirection:(MGradientChangeDirection)m_gradientDirection {
    [self setAssociateWeakValue:@(m_gradientDirection) withKey:@selector(m_gradientDirection)];
}

- (MGradientChangeDirection)m_gradientDirection {
    return [[self getAssociatedValueForKey:@selector(m_gradientDirection)] integerValue];
}

- (void)setM_locations:(NSArray<NSNumber *> *)m_locations {
    [self setAssociateValue:[m_locations copy] withKey:@selector(m_locations)];
}

- (NSArray<NSNumber *> *)m_locations {
    return [self getAssociatedValueForKey:@selector(m_locations)];
}

@end

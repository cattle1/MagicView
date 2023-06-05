//
//  LLActivityIndicatorView.m
//  iOSHelper
//
//  Created by Chair on 2020/4/1.
//  Copyright © 2020 Chair. All rights reserved.
//

#import "MAGActivityIndicatorView.h"

static NSString * identifer = @"animationIdentifier";

@interface MAGActivityIndicatorView ()

/// 指示器集合对象
@property (nonatomic, weak) CAReplicatorLayer *replicatorLayer;

/// 单个指示器对象
@property (nonatomic, weak) CALayer *subLayer;

/// 动画实例对象
@property (nonatomic, strong) CABasicAnimation *fadeAnimation;

@end

@implementation MAGActivityIndicatorView

@synthesize gap = _gap;

#pragma mark - Public
/// 开始/恢复动画。
- (void)startAnimating {
    if (self.fadeAnimation && self.replicatorLayer.speed != 0.0) {/**<防止重复添加动画*/
        return ;
    } else if (self.fadeAnimation && self.replicatorLayer.speed == 0.0) {/**<恢复动画*/
        CFTimeInterval timeSincePause = [self.replicatorLayer convertTime:CACurrentMediaTime() fromLayer:nil] - self.replicatorLayer.timeOffset;
        self.replicatorLayer.speed = 1.0;
        self.replicatorLayer.timeOffset = 0.0;
        self.replicatorLayer.beginTime = timeSincePause;
        return;
    }
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    self.fadeAnimation = fadeAnimation;
    fadeAnimation.fromValue = @(1.0f);
    fadeAnimation.toValue = @(0.0f);
    fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fadeAnimation.duration = self.duration;
    fadeAnimation.removedOnCompletion = NO;
    fadeAnimation.repeatCount = MAXFLOAT;
    
    self.replicatorLayer.instanceDelay = self.duration / (CGFloat)self.number;
    [self.subLayer addAnimation:fadeAnimation forKey:identifer];
}

/// 停止并移除动画，如果不想移除请使用pauseAnimating。
- (void)stopAnimating {
    [self.subLayer removeAnimationForKey:identifer];
    self.fadeAnimation = nil;
}

/// 一个布尔值，返回动画是否存在。
- (BOOL)isAnimating {
    return self.fadeAnimation ? YES : NO;
}

/// 暂停动画，可以通过startAnimating恢复动画。
- (void)pauseAnimating {
    CFTimeInterval pausedTime = [self.replicatorLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.replicatorLayer.speed = 0.0;
    self.replicatorLayer.timeOffset = pausedTime;
}

/// 根据样式创建指示器
/// @param style 指示器样式
+ (instancetype)activityIndicatorWithStyle:(MActivityIndicatorViewStyle)style {
    MAGActivityIndicatorView *view = [[self alloc] init];
    if (view) {
        view.style = style;
    }
    return view;
}

/// 根据颜色创建指示器(默认Medium类型)
/// @param color 指示器颜色
+ (instancetype)activityIndicatorWithColor:(UIColor * _Nullable)color {
    MAGActivityIndicatorView *view = [[self alloc] init];
    if (view) {
        view.style = MActivityIndicatorViewStyleWhiteMedium;
        view.color = color;
    }
    return view;
}

/// 自定义指示器
/// @param color 指示器颜色
/// @param gap 指示器离心距离
/// @param number 指示器个数
/// @param width 指示器宽度
/// @param height 指示器长度
/// @param cornerRadius 指示器圆角
/// @param duration 动画持续时长
+ (instancetype)activityIndicatorWithColor:(UIColor * _Nullable)color gap:(CGFloat)gap number:(NSUInteger)number width:(CGFloat)width height:(CGFloat)height cornerRadius:(CGFloat)cornerRadius duration:(NSTimeInterval)duration {
    MAGActivityIndicatorView *view = [[self alloc] init];
    if (view) {
        view.color        = color;
        view.gap          = gap;
        view.number       = number;
        view.width        = width;
        view.height       = height;
        view.cornerRadius = cornerRadius;
        view.duration     = duration;
    }
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
        [self createSubviews];
    }
    return self;
}


#pragma mark - Private
- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateLayers];
}

- (void)initialize {
    self.backgroundColor = [UIColor clearColor];
    self.color           = [UIColor whiteColor];
    self.gap             = 5.0f;
    self.number          = 12;
    self.width           = 2.5f;
    self.height          = 5.0f;
    self.cornerRadius    = self.width * 0.5;
    self.duration        = 1.0;
}

- (void)createSubviews {
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    self.replicatorLayer = replicatorLayer;
    [self.layer addSublayer:replicatorLayer];
    
    CALayer *subLayer = [CALayer layer];
    self.subLayer = subLayer;
    subLayer.opacity = 0.0f;
    self.subLayer.bounds = CGRectMake(0.0f, 0.0f, self.width, self.height);
    self.subLayer.cornerRadius = self.width * 0.5f;
    self.subLayer.backgroundColor = self.color.CGColor;
    [replicatorLayer addSublayer:subLayer];
    
    CGFloat angle = (2.0 * M_PI) / self.number;
    CATransform3D transform = CATransform3DMakeRotation(angle, 0.0f, 0.0f, 1.0f);
    self.replicatorLayer.instanceCount = self.number;
    self.replicatorLayer.instanceTransform = transform;
}

- (void)updateLayers {
    self.subLayer.position = CGPointMake(CGRectGetWidth(self.bounds) * 0.5f, (CGRectGetWidth(self.bounds) * 0.5f) + (self.height * 0.5f) + self.gap);
    
    self.replicatorLayer.bounds = self.bounds;
    self.replicatorLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

#pragma mark - getter && Setter
- (void)setColor:(UIColor *)color {
    _color = color ?: [UIColor whiteColor];
    self.subLayer.backgroundColor = self.color.CGColor;
}

- (void)setGap:(CGFloat)gap {
    _gap = gap != -1 ? gap : 5.0f;
    self.subLayer.position = CGPointMake(CGRectGetWidth(self.bounds) * 0.5f, (CGRectGetWidth(self.bounds) * 0.5f) + (self.height * 0.5f) + self.gap);
}

- (CGFloat)gap {
    // 限制指示器的离心距离加上指示器高度不会超过UIView本身。
    if (CGRectGetWidth(self.bounds) > 0 && (_gap + self.height > CGRectGetWidth(self.bounds) / 2.0)) {
        _gap = CGRectGetWidth(self.bounds) / 2.0 - self.height;
    }
    return _gap;
}

- (void)setNumber:(NSUInteger)number {
    _number = number != -1 ? number : 12;
    CGFloat angle = (2.0 * M_PI) / self.number;
    CATransform3D transform = CATransform3DMakeRotation(angle, 0.0f, 0.0f, 1.0f);
    self.replicatorLayer.instanceCount = self.number;
    self.replicatorLayer.instanceTransform = transform;
    self.replicatorLayer.instanceDelay = self.duration / (CGFloat)self.number;
}

- (void)setWidth:(CGFloat)width {
    _width = width != -1 ? width : 2.5f;
    CGRect bounds = self.subLayer.bounds;
    bounds.size.width = self.width;
    self.subLayer.bounds = bounds;
    self.cornerRadius = self.width * 0.5f;
}

- (void)setHeight:(CGFloat)height {
    _height = height != -1 ? height : 5.0f;
    CGRect bounds = self.subLayer.bounds;
    bounds.size.height = self.height;
    self.subLayer.bounds = bounds;
    self.subLayer.position = CGPointMake(CGRectGetWidth(self.bounds) * 0.5f, (CGRectGetWidth(self.bounds) * 0.5f) + (self.height * 0.5f) + self.gap);
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius != -1 ? cornerRadius : self.width * 0.5;
    self.subLayer.cornerRadius = self.cornerRadius;
}

- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration != -1 ? duration : 1.0f;
    self.fadeAnimation.duration = self.duration;
    [self.subLayer addAnimation:self.fadeAnimation forKey:identifer];
    self.replicatorLayer.instanceDelay = self.duration / (CGFloat)self.number;
}

- (void)setStyle:(MActivityIndicatorViewStyle)style {
    _style = style;
    switch (style) {
        case MActivityIndicatorViewStyleWhiteMedium:
            self.color = [UIColor whiteColor];
            self.width = 2.5f;
            self.height = 5.0f;
            self.gap = 5.0f;
            break;
        case MActivityIndicatorViewStyleGrayMedium:
            self.color = [UIColor grayColor];
            self.width = 2.5f;
            self.height = 5.0f;
            self.gap = 5.0f;
            break;
        case MActivityIndicatorViewStyleWhiteLarge:
            self.color = [UIColor whiteColor];
            self.width = 3.0f;
            self.height = 10.0f;
            self.gap = 10.0f;
            break;
        case MActivityIndicatorViewStyleGrayLarge:
            self.color = [UIColor grayColor];
            self.width = 3.0f;
            self.height = 10.0f;
            self.gap = 10.0f;
            break;
    }
}

- (CGSize)intrinsicContentSize {
    CGFloat size = (self.height + self.gap) * 2.0;
    return CGSizeMake(size, size);
}

@end

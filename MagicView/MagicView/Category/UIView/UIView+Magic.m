//
//  UIView+Magic.m
//  MagicView
//
//  Created by LL on 2021/8/25.
//

#import "UIView+Magic.h"

#import "MAGImport.h"

#import "MAGActivityIndicatorView.h"

@interface UIView ()

@property (nonatomic, strong) MAGProgressHUD *m_progressHUD;

@property (nonatomic, strong) MAGDelayedBlockHandle m_loadingBlock;

@property (nonatomic, assign) long m_loadingStartTime;

/// 顶部边框
@property (nonatomic, strong) UIView *m_topBorderLine;

/// 左侧边框
@property (nonatomic, strong) UIView *m_leftBorderLine;

/// 底部边框
@property (nonatomic, strong) UIView *m_bottomBorderLine;

/// 右侧边框
@property (nonatomic, strong) UIView *m_rightBorderLine;

@end

@implementation UIView (Magic)

- (void)m_setRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *cornerLayer = [CAShapeLayer layer];
    cornerLayer.path = path.CGPath;
    self.layer.mask = cornerLayer;
}

- (void)m_popViewController {
    [self.viewController m_popViewController];
}

- (UITapGestureRecognizer *)m_addTapGestureRecognizer:(SEL)action {
    return [self m_addTapGestureRecognizer:action target:self];
}

- (UITapGestureRecognizer *)m_addTapGestureRecognizer:(SEL)action target:(id)target {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
    return tap;
}

- (void)setM_frameBlock:(void (^)(id _Nonnull))m_frameBlock {
    [self setAssociateValue:m_frameBlock withKey:@selector(m_frameBlock)];
}

- (void (^)(id _Nonnull))m_frameBlock {
    return [self getAssociatedValueForKey:@selector(m_frameBlock)];
}

@end




@implementation UIView (MAGBorder)

- (void)m_addBorderLineWithStyle:(MBorderLineStyle)borderStyle borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    [self m_addBorderLineWithStyle:borderStyle borderColor:borderColor borderWidth:borderWidth handler:nil];
}

- (void)m_addBorderLineWithStyle:(MBorderLineStyle)borderStyle borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth handler:(void (^ _Nullable)(MBorderLineStyle style, UIView *lineView))handler {
    if (borderStyle == MBorderLineStyleAll) {
        [self m_addBorderLineWithStyle:(MBorderLineStyleTop | MBorderLineStyleLeft | MBorderLineStyleBottom | MBorderLineStyleRight) borderColor:borderColor borderWidth:borderWidth];
        return;
    }
    
    if (borderStyle & MBorderLineStyleTop) {
        self.m_topBorderLine.backgroundColor = borderColor;
        [self.m_topBorderLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(borderWidth);
        }];
        !handler ?: handler(MBorderLineStyleTop, self.m_topBorderLine);
    }
    
    if (borderStyle & MBorderLineStyleLeft) {
        self.m_leftBorderLine.backgroundColor = borderColor;
        [self.m_leftBorderLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(borderWidth);
        }];
        !handler ?: handler(MBorderLineStyleLeft, self.m_leftBorderLine);
    }
    
    if (borderStyle & MBorderLineStyleBottom) {
        self.m_bottomBorderLine.backgroundColor = borderColor;
        [self.m_bottomBorderLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(borderWidth);
        }];
        !handler ?: handler(MBorderLineStyleBottom, self.m_bottomBorderLine);
    }
    
    if (borderStyle & MBorderLineStyleRight) {
        self.m_rightBorderLine.backgroundColor = borderColor;
        [self.m_rightBorderLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(borderWidth);
        }];
        !handler ?: handler(MBorderLineStyleRight, self.m_rightBorderLine);
    }
}

@end




@implementation UIView (MAGLoading)

- (void)m_startLoadingWithColor:(UIColor *)color {
    self.m_loadingBlock = m_dispatch_after(mHUDGraceTime, ^{
        self.m_loadingStartTime = mTimestampMillisecond;
        
        self.userInteractionEnabled = NO;
        if ([self isKindOfClass:UIControl.class]) {
            [(UIControl *)self setEnabled:NO];
        }
        
        // 隐藏所有视图
        self.layer.m_loadingContents = self.layer.contents;
        self.layer.contents = nil;
        for (CALayer *layer in self.layer.sublayers) {
            layer.m_loadingHidden = !layer.hidden;
            layer.m_loadingContents = layer.contents;
            layer.contents = nil;
            if (!layer.isHidden) {
                layer.hidden = YES;
            }
        }
        
        MAGActivityIndicatorView *loadingView = [[MAGActivityIndicatorView alloc] init];
        CGSize size = CGSizeMake(25.0, 25.0);
        loadingView.frame = (CGRect){.size = size};
        loadingView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0);
        loadingView.color = color;
        [loadingView startAnimating];
        
        [self addSubview:loadingView];
    });
}

- (void)m_stopLoading {
    m_cancel_dispatch_after(self.m_loadingBlock);
    
    if (mHUDMinShowTime > 0) {
        NSTimeInterval duration = mTimestampMillisecond - self.m_loadingStartTime;
        duration = duration / 1000.0;// 将毫秒转成秒
        NSTimeInterval showTime = mHUDMinShowTime - duration;
        if (showTime > 0) {
            [self performSelectorWithArgs:@selector(mp_stopLoading) afterDelay:showTime];
        } else {
            [self mp_stopLoading];
        }
    } else {
        [self mp_stopLoading];
    }
}

- (void)mp_stopLoading {
    self.userInteractionEnabled = YES;
    if ([self isKindOfClass:UIControl.class]) {
        [(UIControl *)self setEnabled:YES];
    }
    
    for (MAGActivityIndicatorView *obj in self.subviews) {
        if ([obj isMemberOfClass:MAGActivityIndicatorView.class]) {
            [obj stopAnimating];
            [obj removeFromSuperview];
            break;
        }
    }
    
    // 恢复所有视图
    self.layer.contents = self.layer.m_loadingContents;
    self.layer.m_loadingContents = nil;
    for (CALayer *layer in self.layer.sublayers) {
        if (layer.m_loadingHidden) {
            layer.m_loadingHidden = NO;
            layer.hidden = NO;
        }
        layer.contents = layer.m_loadingContents;
        layer.m_loadingContents = nil;
    }
}

@end




@implementation UIView (MAGProgressHUD)

#pragma mark Loading样式的HUD
- (MAGProgressHUD *)m_showClearHUDFromText:(nullable NSString *)title {
    return [self m_showHUDFromText:title isTranslucent:NO graceTime:mHUDGraceTime];
}

- (MAGProgressHUD *)m_promptShowClearHUDFromText:(nullable NSString *)title {
    return [self m_showHUDFromText:title isTranslucent:NO graceTime:0.0];
}

- (MAGProgressHUD *)m_showDarkHUDFromText:(nullable NSString *)title {
    return [self m_showHUDFromText:title isTranslucent:YES graceTime:mHUDGraceTime];
}

- (MAGProgressHUD *)m_promptShowDarkHUDFromText:(nullable NSString *)title {
    return [self m_showHUDFromText:title isTranslucent:YES graceTime:0.0];
}

- (MAGProgressHUD *)m_showHUDFromText:(NSString *)title isTranslucent:(BOOL)isTranslucent graceTime:(NSTimeInterval)graceTime {
    /// 防止弹出多个信息一样的HUD
    static NSMutableSet<NSString *> *_titleSets = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _titleSets = [NSMutableSet set];
    });
    if (title != nil) {
        if ([_titleSets containsObject:title]) return nil;
        [_titleSets addObject:title];
    }
    
    MAGProgressHUD *hud = [[MAGProgressHUD alloc] initWithView:self];
    self.m_progressHUD = hud;
    hud.bezelView.style = MAGProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = mColorRGB(57, 56, 60);
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MAGProgressHUD class]]].color = UIColor.whiteColor;
    hud.contentColor = UIColor.whiteColor;
    hud.graceTime = graceTime;
    hud.minShowTime = mHUDMinShowTime;
    hud.removeFromSuperViewOnHide = YES;
    if (isTranslucent) {
        hud.backgroundColor = mColorRGBA(0, 0, 0, 0.5);
    }
    hud.completionBlock = ^{
        if (title == nil) return;
        [_titleSets removeObject:title];
    };
    hud.userInteractionEnabled = YES;
    hud.label.text = title;
    hud.label.textColor = hud.contentColor;
    [self addSubview:hud];
    [hud showAnimated:YES];
    return hud;
}


#pragma mark 文字样式的HUD
- (nullable MAGProgressHUD *)m_showErrorHUDFromError:(NSError *)error {
    if (error == nil) return nil;
    
    NSString *message = [NSString m_errorMessageFromCode:error.code];
    message = message ?: @"加载失败";
    return [self m_showErrorHUDFromText:message];
}

- (nullable MAGProgressHUD *)m_showErrorHUDFromText:(NSString *)text {
    return [self m_showTextHUD:text afterDelay:mHUDDuration];
}

- (nullable MAGProgressHUD *)m_showSuccessHUDFromText:(NSString *)text {
    return [self m_showTextHUD:text afterDelay:mHUDDuration];
}

- (MAGProgressHUD *)m_showNormalHUDFromText:(NSString *)text {
    return [self m_showTextHUD:text afterDelay:mHUDDuration];
}

- (nullable MAGProgressHUD *)m_showTextHUD:(NSString *)text afterDelay:(NSTimeInterval)afterDelay {
    if (![text isKindOfClass:NSString.class]) return nil;
    if (text.length == 0) return nil;
    
    
    /// 防止弹出多个信息一样的HUD
    static NSMutableSet<NSString *> *_titleSets = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _titleSets = [NSMutableSet set];
    });
    if ([_titleSets containsObject:text]) return nil;
    [_titleSets addObject:text];
    
    MAGProgressHUD *hud = [MAGProgressHUD showHUDAddedTo:self animated:YES];
    self.m_progressHUD = hud;
    hud.bezelView.style = MAGProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = mColorRGB(57, 56, 60);
    hud.completionBlock = ^{
        [_titleSets removeObject:text];
    };
    hud.userInteractionEnabled = NO;
    hud.mode = MAGProgressHUDModeText;
    hud.label.text = text;
    hud.label.textColor = UIColor.whiteColor;
    hud.offset = CGPointZero;
    [hud hideAnimated:YES afterDelay:afterDelay];
    return hud;
}

- (void)m_hideAnimated:(BOOL)animated {
    [self.m_progressHUD hideAnimated:animated];
    self.m_progressHUD = nil;
}

@end




@implementation UIView (MAGProperty)

#pragma mark - Seeter/Getter
- (void)setM_progressHUD:(MAGProgressHUD *)m_progressHUD {
    [self setAssociateValue:m_progressHUD withKey:@selector(m_progressHUD)];
}

- (MAGProgressHUD *)m_progressHUD {
    return [self getAssociatedValueForKey:@selector(m_progressHUD)];
}

- (void)setM_loadingStartTime:(long)m_loadingStartTime {
    [self setAssociateValue:@(m_loadingStartTime) withKey:@selector(m_loadingStartTime)];
}

- (long)m_loadingStartTime {
    return [[self getAssociatedValueForKey:@selector(m_loadingStartTime)] longValue];
}

- (void)setM_topBorderLine:(UIView *)topBorderLine {
    [self setAssociateValue:topBorderLine withKey:@selector(m_topBorderLine)];
}

- (UIView *)m_topBorderLine {
    UIView *borderLine = [self getAssociatedValueForKey:@selector(m_topBorderLine)];
    if (borderLine == nil) {
        borderLine = [MAGUIFactory view];
        [self setM_topBorderLine:borderLine];
        [self addSubview:borderLine];
        [borderLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(0.0);
        }];
    }
    return borderLine;
}

- (void)setM_leftBorderLine:(UIView *)leftBorderLine {
    [self setAssociateValue:leftBorderLine withKey:@selector(m_leftBorderLine)];
}

- (UIView *)m_leftBorderLine {
    UIView *borderLine = [self getAssociatedValueForKey:@selector(m_leftBorderLine)];
    if (borderLine == nil) {
        borderLine = [MAGUIFactory view];
        [self setM_leftBorderLine:borderLine];
        [self addSubview:borderLine];
        [borderLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
            make.width.mas_equalTo(0.0);
        }];
    }
    return borderLine;
}

- (void)setM_bottomBorderLine:(UIView *)bottomBorderLine {
    [self setAssociateValue:bottomBorderLine withKey:@selector(m_bottomBorderLine)];
}

- (UIView *)m_bottomBorderLine {
    UIView *borderLine = [self getAssociatedValueForKey:@selector(m_bottomBorderLine)];
    if (borderLine == nil) {
        borderLine = [MAGUIFactory view];
        [self setM_bottomBorderLine:borderLine];
        [self addSubview:borderLine];
        [borderLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(0.0);
        }];
    }
    return borderLine;
}

- (void)setM_rightBorderLine:(UIView *)rightBorderLine {
    [self setAssociateValue:rightBorderLine withKey:@selector(m_rightBorderLine)];
}

- (UIView *)m_rightBorderLine {
    UIView *borderLine = [self getAssociatedValueForKey:@selector(m_rightBorderLine)];
    if (borderLine == nil) {
        borderLine = [MAGUIFactory view];
        [self setM_rightBorderLine:borderLine];
        [self addSubview:borderLine];
        [borderLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.width.mas_equalTo(0.0);
        }];
    }
    return borderLine;
}

- (void)setM_loadingBlock:(MAGDelayedBlockHandle)m_loadingBlock {
    [self setAssociateValue:m_loadingBlock withKey:@selector(m_loadingBlock)];
}

- (MAGDelayedBlockHandle)m_loadingBlock {
    return [self getAssociatedValueForKey:@selector(m_loadingBlock)];
}

@end

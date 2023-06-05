//
//  MagicSystemTools.m
//  MagicView
//
//  Created by LL on 2021/7/6.
//

#import "MAGUITools.h"

#import "MAGImport.h"

@implementation MAGUITools

+ (nullable UITabBarController *)currentTabBarController {
    UIViewController *rootVC = mMainWindow.rootViewController;
    if ([rootVC isKindOfClass:UITabBarController.class]) {
        return (UITabBarController *)rootVC;
    } else {
        return nil;
    }
}

+ (nullable UINavigationController *)currentNavigationController {
    UIViewController *viewController = [self currentViewController];
    UINavigationController *navigationController = viewController.navigationController;
    if ([navigationController isKindOfClass:UINavigationController.class]) {
        return navigationController;
    } else {
        return nil;
    }
}

+ (nullable UIViewController *)currentViewController {
    UIViewController *viewController = mMainWindow.rootViewController;
    
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        viewController = [(UITabBarController *)viewController selectedViewController];
    }
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        viewController = [(UINavigationController *)viewController visibleViewController];
    }
    
    if ([viewController isKindOfClass:UIViewController.class]) {
        return viewController;
    } else {
        return nil;
    }
}

+ (nullable UIView *)currentView {
    return [self currentViewController].view;
}

+ (CGFloat)safeAreaInsertTop {
    static CGFloat top;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        top = [self mp_safeAreaInsets].top;
    });
    return top;
}

+ (CGFloat)safeAreaInsertBottom {
    static CGFloat bottom;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bottom = [self mp_safeAreaInsets].bottom;
    });
    return bottom;
}

+ (CGFloat)tabBarHeight {
    static CGFloat _tabBarHeight = 49.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tabBarHeight = mCurrentViewController.tabBarController.tabBar.height;
    });
    return _tabBarHeight;
}

+ (CGFloat)navigationBarHeight {
    return 44.0;
}

+ (CGFloat)calcTextHeightFromFont:(UIFont *)font {
    return [self calcTextSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) text:@"我" numberOfLines:1 font:font textAlignment:NSTextAlignmentLeft lineBreakMode:kNilOptions minimumScaleFactor:0.0 shadowOffset:CGSizeZero].height;
}

+ (CGSize)calcTextSize:(CGSize)fitSize text:(id)text numberOfLines:(NSInteger)numberOfLines font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode minimumScaleFactor:(CGFloat)minimumScaleFactor shadowOffset:(CGSize)shadowOffset {
    if (!text || [text length] <= 0) {
        return CGSizeZero;
    }
    
    NSAttributedString *calcAttributedString = nil;
    
    // 如果不指定字体则使用默认字体
    if (font == nil) {
        font = [UIFont systemFontOfSize:17.0];
    }
    
    CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = textAlignment;
    paragraphStyle.lineBreakMode = lineBreakMode;
    
    // 系统大于11才设置行断字策略
    if (systemVersion >= 11.0) {
        @try {
            [paragraphStyle setValue:@(1) forKey:@"lineBreakStrategy"];
        } @catch (NSException *exception) {}
    }
    
    if ([text isKindOfClass:NSString.class]) {
        calcAttributedString = [[NSAttributedString alloc] initWithString:(NSString *)text attributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle}];
    } else {
        NSAttributedString *originAttributeString = (NSAttributedString *)text;
        // 对于属性字符串总是加上默认的字体和段落信息
        NSMutableAttributedString *mutableCalcAttributedString = [[NSMutableAttributedString alloc] initWithString:originAttributeString.string attributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle}];
        
        [originAttributeString enumerateAttributesInRange:NSMakeRange(0, originAttributeString.string.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            [mutableCalcAttributedString addAttributes:attrs range:range];
        }];
        
        // 这里再次取段落信息，因为有可能属性字符串中就已经包含了段落信息
        if (systemVersion >= 11.0) {
            NSParagraphStyle *alternativeParagraphStyle = [mutableCalcAttributedString attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
            if (alternativeParagraphStyle != nil) {
                paragraphStyle = (NSMutableParagraphStyle *)alternativeParagraphStyle;
            }
        }
        
        calcAttributedString = mutableCalcAttributedString;
    }
    
    // 调整fitSize的值，这里的宽度调整为只要宽度小于等于0或者显示一行都不限制宽度，而高度则总是改为不限制
    fitSize.height = FLT_MAX;
    if (fitSize.width <= 0 || numberOfLines == 1) {
        fitSize.width = FLT_MAX;
    }
    
    // 构造出一个NSStringDrawContext
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    context.minimumScaleFactor = minimumScaleFactor;
    @try {
        // 因为下面几个属性都是未公开的属性，所以使用KVC
        [context setValue:@(numberOfLines) forKey:@"maximumNumberOfLines"];
        if (numberOfLines != 1) {
            [context setValue:@(YES) forKey:@"wrapsForTruncationMode"];
        }
        [context setValue:@(YES) forKey:@"wantsNumberOfLineFragments"];
    } @catch (NSException *exception) {}
    
    // 计算属性字符串的bounds值
    CGRect rect = [calcAttributedString boundingRectWithSize:fitSize options:NSStringDrawingUsesLineFragmentOrigin context:context];
    
    // 需要对段落的首行缩进进行特殊处理
    // 如果只有一行则直接添加首行缩进的值，否则进行特殊处理
    CGFloat firstLineHeadIndent = paragraphStyle.firstLineHeadIndent;
    if (firstLineHeadIndent != 0.0 && systemVersion >= 11.0) {
        // 得到绘制出来的行数
        NSInteger numberOfDrawingLines = [[context valueForKey:@"numberOfLineFragments"] integerValue];
        if (numberOfDrawingLines == 1) {
            rect.size.width += firstLineHeadIndent;
        } else {
            // 取内容的行数
            NSString *string = calcAttributedString.string;
            NSCharacterSet *charset = [NSCharacterSet newlineCharacterSet];
            NSArray *lines = [string componentsSeparatedByCharactersInSet:charset];// 得到文本内容的行数
            NSString *lastLine = lines.lastObject;
            NSInteger numberOfContentLines = lines.count - (NSInteger)(lastLine.length == 0); // 有效的内容行数要减去最后一行为空行的情况。
            if (numberOfLines == 0) {
                numberOfLines = NSIntegerMax;
            }
            if (numberOfLines > numberOfContentLines) {
                numberOfLines = numberOfContentLines;
            }
            
            // 只有绘制的行数和指定的行数相等时才添加上首行缩进，这段代码根据反汇编来实现，但是不理解为什么相等才设置？
            if (numberOfDrawingLines == numberOfLines) {
                rect.size.width += firstLineHeadIndent;
            }
        }
    }
    
    // 取fitSize和rect中的最小宽度值
    if (rect.size.width > fitSize.width) {
        rect.size.width = fitSize.width;
    }
    
    // 加上阴影的偏移
    rect.size.width += fabs(shadowOffset.width);
    rect.size.height += fabs(shadowOffset.height);
    
    // 转化为可以有效显示的逻辑点，这里将原始逻辑点乘以缩放比例得到物理像素点，然后再取整，然后再除以缩放比例得到可以有效显示的逻辑点。
    CGFloat scale = [UIScreen mainScreen].scale;
    rect.size.width = ceil(rect.size.width * scale) / scale;
    rect.size.height = ceil(rect.size.height * scale) / scale;
    
    return rect.size;
}


#pragma mark - Private
+ (UIEdgeInsets)mp_safeAreaInsets {
    static UIEdgeInsets insets;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11.0, *)) {
            insets = mMainWindow.safeAreaInsets;
        }
        
        if (insets.top == 0) {
            CGFloat statusBarHeight = 0;
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_13_0
            statusBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
#else
            if (@available(iOS 13.0, *)) {
                for (UIWindowScene *windowScene in UIApplication.sharedApplication.connectedScenes) {
                    for (UIWindow *obj in windowScene.windows) {
                        if (obj == UIApplication.sharedApplication.delegate.window) {
                            statusBarHeight = CGRectGetHeight(windowScene.statusBarManager.statusBarFrame);
                            break;
                        }
                    }
                    if (statusBarHeight != 0) break;
                }
            } else {
                statusBarHeight = CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame);
            }
#endif
            
            if (statusBarHeight == 0) statusBarHeight = 20;
            insets.top = statusBarHeight;
        }
    });
    return insets;
}

@end

//
//  ZTUIFactory.m
//  ZTCloud
//
//  Created by LL on 2021/3/10.
//

#import "MAGUIFactory.h"

#import "MAGTableSectionView.h"
#import "MAGView.h"
#import "MAGLabel.h"
#import "MAGYYLabel.h"
#import "MAGImageView.h"
#import "MAGAnimatedImageView.h"
#import "MAGButton.h"
#import "MAGTextField.h"
#import "MAGScrollView.h"
#import "MAGTextView.h"
#import "MAGYYTextView.h"
#import "MAGTableView.h"
#import "MAGCollectionView.h"

@implementation MAGUIFactory

#pragma mark - UIView
+ (UIView *)view {
    return [self viewWithBackgroundColor:nil cornerRadius:0.0];
}

+ (UIView *)viewWithBackgroundColor:(nullable UIColor *)backgroudColor cornerRadius:(CGFloat)cornerRadius {
    MAGView *view = [[MAGView alloc] init];
    view.userInteractionEnabled = YES;
    view.backgroundColor = backgroudColor ?: [UIColor clearColor];
    view.layer.cornerRadius = cornerRadius;
    return view;
}


#pragma mark UILabel
+ (UILabel *)label {
    return [self labelWithBackgroundColor:nil font:nil textColor:nil];
}

+ (UILabel *)labelWithBackgroundColor:(nullable UIColor *)backgroudColor font:(nullable UIFont *)font textColor:(nullable UIColor *)textColor {
    MAGLabel *label = [[MAGLabel alloc] init];
    label.userInteractionEnabled = YES;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font ?: [UIFont systemFontOfSize:14.0];
    label.backgroundColor = backgroudColor ?: [UIColor clearColor];
    label.textColor = textColor ?: [UIColor blackColor];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

+ (YYLabel *)yyLabel {
    return [self yyLabelWithBackgroundColor:nil font:nil textColor:nil];
}

+ (YYLabel *)yyLabelWithBackgroundColor:(nullable UIColor *)backgroudColor font:(nullable UIFont *)font textColor:(nullable UIColor *)textColor {
    MAGYYLabel *label = [[MAGYYLabel alloc] init];
    label.userInteractionEnabled = YES;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font ?: [UIFont systemFontOfSize:14.0];
    label.backgroundColor = backgroudColor ?: [UIColor clearColor];
    label.textColor = textColor ?: [UIColor blackColor];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

#pragma mark UIImageView
+ (UIImageView *)imageView {
    return [self imageViewWithBackgroundColor:nil image:nil cornerRadius:0.0];
}

+ (UIImageView *)imageViewWithBackgroundColor:(nullable UIColor *)backgroundColor image:(nullable UIImage *)image cornerRadius:(CGFloat)cornerRadius {
    MAGImageView *imageView = [[MAGImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = backgroundColor ?: [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.image = image;
    if (cornerRadius > 0) {
        imageView.layer.cornerRadius = cornerRadius;
        imageView.layer.masksToBounds = YES;
    }
    return imageView;
}

+ (YYAnimatedImageView *)yyImageView {
    return [self yyImageViewWithBackgroundColor:nil image:nil cornerRadius:0.0];
}

+ (YYAnimatedImageView *)yyImageViewWithBackgroundColor:(nullable UIColor *)backgroundColor image:(nullable UIImage *)image cornerRadius:(CGFloat)cornerRadius {
    MAGAnimatedImageView *yyimageView = [[MAGAnimatedImageView alloc] init];
    yyimageView.userInteractionEnabled = YES;
    yyimageView.backgroundColor = backgroundColor ?: [UIColor clearColor];
    yyimageView.contentMode = UIViewContentModeScaleAspectFill;
    yyimageView.clipsToBounds = YES;
    yyimageView.image = image;
    if (cornerRadius > 0) {
        yyimageView.layer.cornerRadius = cornerRadius;
    }
    return yyimageView;
}


#pragma mark UIButton
+ (UIButton *)buttonWithTarget:(nullable id)target action:(nullable SEL)action {
    return [self buttonWithType:UIButtonTypeSystem backgroundColor:nil font:nil textColor:nil target:target action:action];
}

+ (UIButton *)buttonWithType:(UIButtonType)type backgroundColor:(nullable UIColor *)backgroudColor font:(nullable UIFont *)font textColor:(nullable UIColor *)textColor target:(nullable id)target action:(nullable SEL)action {
    MAGButton *button = [MAGButton buttonWithType:type];
    button.backgroundColor = backgroudColor ?: [UIColor clearColor];
    [button setTitleColor:textColor ?: [UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = font ?: [UIFont systemFontOfSize:14.0];
    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}


#pragma mark UITextField
+ (UITextField *)textField {
    return [self textFieldWithBackgroundColor:nil placeholder:@"" textColor:nil font:nil delegate:nil isNumber:NO];
}

+ (UITextField *)textFieldWithBackgroundColor:(nullable UIColor *)backgroundColor placeholder:(NSString *)placeholder textColor:(nullable UIColor *)textColor font:(nullable UIFont *)font delegate:(nullable id<UITextFieldDelegate>)delegate isNumber:(BOOL)isNumber {
    MAGTextField *textField = [[MAGTextField alloc] init];
    textField.backgroundColor = backgroundColor ?: [UIColor clearColor];
    textField.keyboardType = isNumber ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
    textField.font = font ?: [UIFont systemFontOfSize:14.0];
    textField.placeholder = placeholder ?: @"";
    textField.textColor = textColor ?: [UIColor blackColor];
    if (delegate) {
        textField.delegate = delegate;
    }
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textField;
}


#pragma mark - UIScrollView
+ (UIScrollView *)scrollView {
    return [self scrollViewWithBackgroundColor:nil delegate:nil];
}

+ (UIScrollView *)scrollViewWithBackgroundColor:(nullable UIColor *)backgroundColor delegate:(nullable id<UIScrollViewDelegate>)delegate {
    MAGScrollView *scrollView = [[MAGScrollView alloc] init];
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    scrollView.backgroundColor = backgroundColor ?: [UIColor clearColor];
    if (delegate) {
        scrollView.delegate = delegate;
    }
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.appearanceBindUpdater = ^(UIScrollView * _Nonnull bindView) {
        if (bindView.isDarkMode) {
            bindView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        } else {
            bindView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        }
    };
    return scrollView;
}


#pragma mark UITextView
+ (UITextView *)textView {
    return [self textViewWithBackgroundColor:nil delegate:nil textColor:nil font:nil editable:YES];
}

+ (UITextView *)textViewWithBackgroundColor:(nullable UIColor *)backgroundColor delegate:(nullable id<UITextViewDelegate>)delegate textColor:(nullable UIColor *)textColor font:(nullable UIFont *)font editable:(BOOL)editable {
    MAGTextView *textView = [[MAGTextView alloc] init];
    if (@available(iOS 11.0, *)) {
        textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    textView.backgroundColor = backgroundColor ?: [UIColor clearColor];
    textView.textColor = textColor ?: [UIColor blackColor];
    textView.font = font ?: [UIFont systemFontOfSize:14.0];
    textView.editable = editable;
    if (delegate) {
        textView.delegate = delegate;
    }
    textView.appearanceBindUpdater = ^(UITextView * _Nonnull bindView) {
        if (bindView.isDarkMode) {
            bindView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        } else {
            bindView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        }
    };
    return textView;
}

+ (YYTextView *)yyTextView {
    return [self yyTextViewWithBackgroundColor:nil delegate:nil textColor:nil font:nil editable:YES];
}

+ (YYTextView *)yyTextViewWithBackgroundColor:(nullable UIColor *)backgroundColor delegate:(nullable id<YYTextViewDelegate>)delegate textColor:(nullable UIColor *)textColor font:(nullable UIFont *)font editable:(BOOL)editable {
    MAGYYTextView *textView = [[MAGYYTextView alloc] init];
    if (@available(iOS 11.0, *)) {
        textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    textView.backgroundColor = backgroundColor ?: [UIColor clearColor];
    textView.textColor = textColor ?: [UIColor blackColor];
    textView.font = font ?: [UIFont systemFontOfSize:14.0];
    textView.editable = editable;
    textView.textContainerInset = UIEdgeInsetsZero;
    if (delegate) {
        textView.delegate = delegate;
    }
    textView.appearanceBindUpdater = ^(UITextView * _Nonnull bindView) {
        if (bindView.isDarkMode) {
            bindView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        } else {
            bindView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        }
    };
    return textView;
}


#pragma mark UITableView
+ (UITableView *)tableView {
    return [self tableViewWithBackgroundColor:nil delegate:nil style:UITableViewStylePlain cellClass:nil];
}

+ (UITableView *)tableViewWithBackgroundColor:(UIColor *)backgroundColor delegate:(id<UITableViewDataSource,UITableViewDelegate>)delegate style:(UITableViewStyle)style cellClass:(NSArray<Class> *)cellClass {
    MAGTableView *tableView = [[MAGTableView alloc] initWithFrame:CGRectZero style:style];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = backgroundColor ?: [UIColor clearColor];
    tableView.estimatedRowHeight = 45.0;
    tableView.estimatedSectionHeaderHeight = 0.0;
    tableView.estimatedSectionFooterHeight = 0.0;
    tableView.rowHeight = UITableViewAutomaticDimension;
    if (delegate) {
        tableView.delegate = delegate;
        tableView.dataSource = delegate;
    }
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    for (Class obj in cellClass) {
        [tableView registerClass:obj forCellReuseIdentifier:NSStringFromClass(obj)];
    }
    tableView.appearanceBindUpdater = ^(UITableView * _Nonnull bindView) {
        if (bindView.isDarkMode) {
            bindView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        } else {
            bindView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        }
    };
    [tableView registerClass:MAGTableSectionView.class forHeaderFooterViewReuseIdentifier:MAGTableSectionView.className];
    return tableView;
}

#pragma mark UICollectionView
+ (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    UICollectionViewFlowLayout *mainCollectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    mainCollectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    return mainCollectionViewFlowLayout;
}

+ (UICollectionView *)collectionViewWithLayout:(UICollectionViewLayout *)layout {
    return [self collectionViewWithLayout:layout backgroundColor:nil delegate:nil cellClass:nil];
}

+ (UICollectionView *)collectionViewWithLayout:(UICollectionViewLayout *)layout backgroundColor:(nullable UIColor *)backgroundColor delegate:(nullable id<UICollectionViewDataSource, UICollectionViewDelegate>)delegate cellClass:(nullable NSArray<Class> *)cellClass {
    MAGCollectionView *collectionView = [[MAGCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = backgroundColor ?: [UIColor clearColor];
    if (delegate) {
        collectionView.dataSource = delegate;
        collectionView.delegate = delegate;
    }
    collectionView.alwaysBounceVertical = YES;
    collectionView.userInteractionEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    for (Class obj in cellClass) {
        [collectionView registerClass:obj forCellWithReuseIdentifier:NSStringFromClass(obj)];
    }
    collectionView.appearanceBindUpdater = ^(UICollectionView * _Nonnull bindView) {
        if (bindView.isDarkMode) {
            bindView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        } else {
            bindView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        }
    };
    return collectionView;
}

@end

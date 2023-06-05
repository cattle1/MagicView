//
//  ZTUIFactory.h
//  ZTCloud
//
//  Created by LL on 2021/3/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAGUIFactory : NSObject

#pragma mark - UIView
+ (UIView *)view;

+ (UIView *)viewWithBackgroundColor:(nullable UIColor *)backgroudColor cornerRadius:(CGFloat)cornerRadius;


#pragma mark UILabel
+ (UILabel *)label;

+ (UILabel *)labelWithBackgroundColor:(nullable UIColor *)backgroudColor font:(nullable UIFont *)font textColor:(nullable UIColor *)textColor;

+ (YYLabel *)yyLabel;

+ (YYLabel *)yyLabelWithBackgroundColor:(nullable UIColor *)backgroudColor font:(nullable UIFont *)font textColor:(nullable UIColor *)textColor;


#pragma mark UIImageView
+ (UIImageView *)imageView;

+ (UIImageView *)imageViewWithBackgroundColor:(nullable UIColor *)backgroundColor image:(nullable UIImage *)image cornerRadius:(CGFloat)cornerRadius;

+ (YYAnimatedImageView *)yyImageView;

+ (YYAnimatedImageView *)yyImageViewWithBackgroundColor:(nullable UIColor *)backgroundColor image:(nullable UIImage *)image cornerRadius:(CGFloat)cornerRadius;


#pragma mark UIButton
+ (UIButton *)buttonWithTarget:(nullable id)target action:(nullable SEL)action;

+ (UIButton *)buttonWithType:(UIButtonType)type backgroundColor:(nullable UIColor *)backgroudColor font:(nullable UIFont *)font textColor:(nullable UIColor *)textColor target:(nullable id)target action:(nullable SEL)action;


#pragma mark UITextField
+ (UITextField *)textField;

+ (UITextField *)textFieldWithBackgroundColor:(nullable UIColor *)backgroundColor placeholder:(nullable NSString *)placeholder textColor:(nullable UIColor *)textColor font:(nullable UIFont *)font delegate:(nullable id<UITextFieldDelegate>)delegate isNumber:(BOOL)isNumber;


#pragma mark - UIScrollView
+ (UIScrollView *)scrollView;

+ (UIScrollView *)scrollViewWithBackgroundColor:(nullable UIColor *)backgroundColor delegate:(nullable id<UIScrollViewDelegate>)delegate;


#pragma mark UITextView
+ (UITextView *)textView;

+ (UITextView *)textViewWithBackgroundColor:(nullable UIColor *)backgroundColor delegate:(nullable id<UITextViewDelegate>)delegate textColor:(nullable UIColor *)textColor font:(nullable UIFont *)font editable:(BOOL)editable;

+ (YYTextView *)yyTextView;

+ (YYTextView *)yyTextViewWithBackgroundColor:(nullable UIColor *)backgroundColor delegate:(nullable id<YYTextViewDelegate>)delegate textColor:(nullable UIColor *)textColor font:(nullable UIFont *)font editable:(BOOL)editable;


#pragma mark UITableView
/// 创建一个不分组的UITableView
+ (UITableView *)tableView;

/// 创建UITableView 背景颜色 代理 cell数组
+ (UITableView *)tableViewWithBackgroundColor:(nullable UIColor *)backgroundColor delegate:(nullable id<UITableViewDataSource, UITableViewDelegate>)delegate style:(UITableViewStyle)style cellClass:(nullable NSArray<Class> *)cellClass;


#pragma mark UICollectionView
/// 创建一个样式为 UICollectionViewScrollDirectionVertical 的FlowLayout
+ (UICollectionViewFlowLayout *)collectionViewFlowLayout;

+ (UICollectionView *)collectionViewWithLayout:(UICollectionViewLayout *)layout;

+ (UICollectionView *)collectionViewWithLayout:(UICollectionViewLayout *)layout backgroundColor:(nullable UIColor *)backgroundColor delegate:(nullable id<UICollectionViewDataSource, UICollectionViewDelegate>)delegate cellClass:(nullable NSArray<Class> *)cellClass;

@end

NS_ASSUME_NONNULL_END

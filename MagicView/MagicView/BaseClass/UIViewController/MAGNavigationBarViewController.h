//
//  MagicNavigationBarViewController.h
//  MagicView
//
//  Created by LL on 2021/7/6.
//

#import "MAGAbstractViewController.h"

#import "MAGNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGNavigationBarViewController : MAGAbstractViewController

@property (nonatomic, weak) MAGNavigationBar *navigationBar;

@property (nonatomic, assign) BOOL navigationBarHidden;

/// 一个布尔值，用于控制导航栏是否显示在最上层，默认值为NO
@property (nonatomic, assign) BOOL bringNavigationBarToFront;

@property (nonatomic, copy, nullable) NSString *navigationBarTitle;

@property (nonatomic, strong, nullable) UIColor *navigationBarBackgroundColor;

@property (nonatomic, copy, nullable) NSAttributedString *navigationBarAttributedString;

@property (nonatomic, strong, nullable) UIColor *navigationBarTitleColor;

@property (nonatomic, strong, nullable) UIColor *navigationBarBackButtonColor;

@property (nonatomic, assign) BOOL navigationBarBackButtonHidden;

@property (nonatomic, strong, nullable) UIColor *navigationBarBottomLineViewColor;

@property (nonatomic, assign) BOOL navigationBarBottomLineViewHidden;

@end

NS_ASSUME_NONNULL_END

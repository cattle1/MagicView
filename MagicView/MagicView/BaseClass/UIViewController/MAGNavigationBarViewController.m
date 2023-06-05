//
//  MagicNavigationBarViewController.m
//  MagicView
//
//  Created by LL on 2021/7/6.
//

#import "MAGNavigationBarViewController.h"

@implementation MAGNavigationBarViewController

- (instancetype)init {
    if (self = [super init]) {
        _bringNavigationBarToFront = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MAGNavigationBar *navigationBar = [[MAGNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, mNavBarHeight)];
    self.navigationBar = navigationBar;
    navigationBar.backgroundColor = mNavBarBackgroundColor;
    navigationBar.backImageView.hidden = (self.navigationController.viewControllers.count == 1);
    [self.view addSubview:navigationBar];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.bringNavigationBarToFront) {
        [self.view bringSubviewToFront:self.navigationBar];
    }
}


#pragma mark - Setter
- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    self.navigationBar.hidden = navigationBarHidden;
}

- (void)setNavigationBarBackgroundColor:(UIColor *)color {
    self.navigationBar.backgroundColor = color;
}

- (void)setNavigationBarTitle:(NSString *)title {
    self.navigationBar.titleLabel.text = [title copy];
}

- (void)setNavigationBarTitleColor:(UIColor *)color {
    self.navigationBar.titleLabel.textColor = color;
}

- (void)setNavigationBarAttributedString:(NSAttributedString *)attributedString {
    self.navigationBar.titleLabel.attributedText = [attributedString copy];
}

- (void)setNavigationBarBackButtonColor:(UIColor *)color {
    self.navigationBar.backImageView.tintColor = color;
}

- (void)setNavigationBarBackButtonHidden:(BOOL)hidden {
    self.navigationBar.backImageView.hidden = hidden;
}

- (void)setNavigationBarBottomLineViewColor:(UIColor *)color {
    self.navigationBar.bottomLineView.backgroundColor = color;
}

- (void)setNavigationBarBottomLineViewHidden:(BOOL)hidden {
    self.navigationBar.bottomLineView.hidden = hidden;
}

- (void)setBringNavigationBarToFront:(BOOL)bringNavigationBarToFront {
    _bringNavigationBarToFront = bringNavigationBarToFront;
    if (bringNavigationBarToFront) {
        [self.view bringSubviewToFront:self.navigationBar];
    }
}


#pragma mark - Getter
- (BOOL)navigationBarHidden {
    return self.navigationBar.hidden;
}

- (UIColor *)navigationBarBackgroundColor {
    return self.navigationBar.backgroundColor;
}

- (NSString *)navigationBarTitle {
    return self.navigationBar.titleLabel.text;
}

- (UIColor *)navigationBarTitleColor {
    return self.navigationBar.titleLabel.textColor;
}

- (NSAttributedString *)navigationBarAttributedString {
    return self.navigationBar.titleLabel.attributedText;
}

- (UIColor *)navigationBarBackButtonColor {
    return self.navigationBar.backImageView.tintColor;
}

- (BOOL)navigationBarBackButtonHidden {
    return self.navigationBar.backImageView.hidden;
}

- (UIColor *)navigationBarBottomLineViewColor {
    return self.navigationBar.bottomLineView.backgroundColor;
}

- (BOOL)navigationBarBottomLineViewHidden {
    return self.navigationBar.bottomLineView.hidden;
}

@end

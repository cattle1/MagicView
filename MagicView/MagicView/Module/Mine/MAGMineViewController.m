//
//  MAGMineViewController.m
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import "MAGMineViewController.h"

@implementation MAGMineViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [MAGClickAgent appendDidAppearViewControllerName:@"个人中心页面"];
    [MAGClickAgent event:@"用户进入个人中心页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MAGClickAgent event:@"用户离开个人中心页面"];
}

@end

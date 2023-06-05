//
//  MAGAboutUSViewController.m
//  MagicView
//
//  Created by LL on 2021/10/21.
//

#import "MAGAboutUSViewController.h"

#import "MAGAboutUSViewController1.h"

@implementation MAGAboutUSViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [MAGClickAgent appendDidAppearViewControllerName:@"关于页面"];
    [MAGClickAgent event:@"用户进入关于页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MAGClickAgent event:@"用户离开关于页面"];
}

+ (instancetype)aboutUSViewController {
    return [[MAGAboutUSViewController1 alloc] init];
}

@end

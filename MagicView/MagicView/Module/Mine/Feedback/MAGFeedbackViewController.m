//
//  MAGFeedbackViewController.m
//  MagicView
//
//  Created by LL on 2021/10/20.
//

#import "MAGFeedbackViewController.h"

#import "MAGFeedbackViewController1.h"

@implementation MAGFeedbackViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [MAGClickAgent appendDidAppearViewControllerName:@"反馈页面页面"];
    [MAGClickAgent event:@"用户进入反馈页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MAGClickAgent event:@"用户离开反馈页面"];
}

+ (instancetype)feedbackViewController {
    return [[MAGFeedbackViewController1 alloc] init];
}

@end

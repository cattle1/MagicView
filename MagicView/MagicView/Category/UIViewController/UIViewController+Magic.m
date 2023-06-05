//
//  UIViewController+Magic.m
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import "UIViewController+Magic.h"

@implementation UIViewController (Magic)

- (void)m_popViewController {
    if (self.navigationController.viewControllers.count <= 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

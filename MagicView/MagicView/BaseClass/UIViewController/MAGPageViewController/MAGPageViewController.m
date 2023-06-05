//
//  MAGPageViewController.m
//  MagicView
//
//  Created by LL on 2021/9/15.
//

#import "MAGPageViewController.h"

@implementation MAGPageViewController

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];
}

@end

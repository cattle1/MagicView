//
//  YYAnimatedImageView+Util.m
//  WXReader
//
//  Created by LL on 2020/10/9.
//  Copyright © 2020 Andrew. All rights reserved.
//

#import "YYAnimatedImageView+Util.h"

@implementation YYAnimatedImageView (Util)

+ (void)load {
    [self swizzleInstanceMethod:@selector(displayLayer:) with:@selector(displayLayerNew:)];
}

- (void)displayLayerNew:(CALayer *)layer {
    Ivar imgIvar = class_getInstanceVariable([self class], "_curFrame");
    UIImage *img = object_getIvar(self, imgIvar);
    if (img) {
        layer.contents = (__bridge id)img.CGImage;
    } else {
        if (@available(iOS 14.0, *)) {
            [super displayLayer:layer];
        }
    }
}

@end

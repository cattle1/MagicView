//
//  UIImageView+Magic.m
//  MagicView
//
//  Created by LL on 2021/8/30.
//

#import "UIImageView+Magic.h"

@implementation UIImageView (Magic)

- (void)m_setRenderingModeAlwaysTemplateImageWithURL:(NSURL *)imageURL placeholder:(nullable UIImage *)placeholder {
    [self m_setRenderingModeAlwaysTemplateImageWithURL:imageURL placeholder:placeholder size:CGSizeZero];
}

- (void)m_setRenderingModeAlwaysTemplateImageWithURL:(NSURL *)imageURL placeholder:(nullable UIImage *)placeholder size:(CGSize)size {
    [self m_setRenderingModeAlwaysTemplateImageWithURL:imageURL placeholder:placeholder size:size insetEdge:UIEdgeInsetsZero];
}

- (void)m_setRenderingModeAlwaysTemplateImageWithURL:(NSURL *)imageURL
                                         placeholder:(nullable UIImage *)placeholder
                                                size:(CGSize)size
                                           insetEdge:(UIEdgeInsets)insetEdge {
    __weak typeof(self) weakSelf = self;
    [self setImageWithURL:imageURL placeholder:placeholder options:kNilOptions completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (image == nil) return;
        if (!CGSizeEqualToSize(size, CGSizeZero)) {
            image = [image imageByResizeToSize:size];
        }
        if (!UIEdgeInsetsEqualToEdgeInsets(insetEdge, UIEdgeInsetsZero)) {
            image = [image imageByInsetEdge:insetEdge withColor:UIColor.clearColor];
        }
        
        weakSelf.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }];
}

@end

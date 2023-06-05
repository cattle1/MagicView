//
//  UIImageView+Magic.h
//  MagicView
//
//  Created by LL on 2021/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Magic)

- (void)m_setRenderingModeAlwaysTemplateImageWithURL:(NSURL *)imageURL placeholder:(nullable UIImage *)placeholder;

- (void)m_setRenderingModeAlwaysTemplateImageWithURL:(NSURL *)imageURL placeholder:(nullable UIImage *)placeholder size:(CGSize)size;

- (void)m_setRenderingModeAlwaysTemplateImageWithURL:(NSURL *)imageURL
                                         placeholder:(nullable UIImage *)placeholder
                                                size:(CGSize)size
                                           insetEdge:(UIEdgeInsets)insetEdge;

@end

NS_ASSUME_NONNULL_END

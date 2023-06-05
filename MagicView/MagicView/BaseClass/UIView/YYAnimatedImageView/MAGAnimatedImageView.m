//
//  MAGAnimatedImageView.m
//  MagicView
//
//  Created by LL on 2021/9/7.
//

#import "MAGAnimatedImageView.h"

@implementation MAGAnimatedImageView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    !self.m_frameBlock ?: self.m_frameBlock(self);
}

@end

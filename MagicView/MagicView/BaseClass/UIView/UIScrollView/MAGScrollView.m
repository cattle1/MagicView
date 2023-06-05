//
//  MAGScrollView.m
//  MagicView
//
//  Created by LL on 2021/9/7.
//

#import "MAGScrollView.h"

@implementation MAGScrollView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    !self.m_frameBlock ?: self.m_frameBlock(self);
}

@end

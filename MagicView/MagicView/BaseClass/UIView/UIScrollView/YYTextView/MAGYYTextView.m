//
//  MAGYYTextView.m
//  MagicView
//
//  Created by LL on 2021/9/7.
//

#import "MAGYYTextView.h"

@implementation MAGYYTextView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    !self.m_frameBlock ?: self.m_frameBlock(self);
}

@end

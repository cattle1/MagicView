//
//  MAGTextField.m
//  MagicView
//
//  Created by LL on 2021/9/7.
//

#import "MAGTextField.h"

@implementation MAGTextField

- (void)layoutSubviews {
    [super layoutSubviews];
    
    !self.m_frameBlock ?: self.m_frameBlock(self);
}

@end

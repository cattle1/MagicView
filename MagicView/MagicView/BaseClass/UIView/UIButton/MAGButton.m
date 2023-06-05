//
//  MAGButton.m
//  MagicView
//
//  Created by LL on 2021/9/7.
//

#import "MAGButton.h"

@implementation MAGButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.m_maxLayoutWidthEqualWidth) {
        CGFloat textHeight = self.m_textHeight;
        if (self.height != textHeight) {
            self.height = textHeight;
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(textHeight);
            }];
        }
    }
    
    if (self.m_cornerRadius == MAGButtonCornerRadiusAdjustsBounds) {
        if (CGRectGetHeight(self.bounds) > 0) {        
            self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2.0;
        }
    }
    
    !self.m_frameBlock ?: self.m_frameBlock(self);
}

@end

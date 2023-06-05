//
//  MAGLabel.m
//  MagicView
//
//  Created by LL on 2021/9/3.
//

#import "MAGLabel.h"

@implementation MAGLabel

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.m_edgeInsets)];
}

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
    
    !self.m_frameBlock ?: self.m_frameBlock(self);
}

@end

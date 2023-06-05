//
//  UIFont+Magic.m
//  MagicView
//
//  Created by LL on 2021/8/22.
//

#import "UIFont+Magic.h"

@implementation UIFont (Magic)

- (CGFloat)m_textHeight {
    return [@"测" heightForFont:self width:CGFLOAT_MAX];
}

@end

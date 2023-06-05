//
//  UIButton+Magic.m
//  MagicView
//
//  Created by LL on 2021/9/17.
//

#import "UIButton+Magic.h"

#import "MAGUITools.h"
#import "MAGButton.h"

@implementation UIButton (Magic)

- (CGFloat)m_textWidth {
    return [self m_textWidthForState:UIControlStateNormal];
}

- (CGFloat)m_textHeight {
    return [self m_textHeightForState:UIControlStateNormal];
}

- (CGSize)m_textSize {
    return [self m_textSizeForState:UIControlStateNormal];
}

- (CGFloat)m_textWidthForState:(UIControlState)state {
    NSAttributedString *attributedText = [self attributedTitleForState:state];
    if (attributedText) {
        return [MAGUITools calcTextSize:CGSizeMake(CGFLOAT_MAX, 30.0)
                                 text:attributedText
                        numberOfLines:1
                                 font:nil
                        textAlignment:attributedText.alignment
                        lineBreakMode:attributedText.lineBreakMode
                   minimumScaleFactor:0
                         shadowOffset:CGSizeZero].width;
    }
    
    NSString *text = [self titleForState:state];
    if (text) {
        return [MAGUITools calcTextSize:CGSizeMake(CGFLOAT_MAX, 30.0)
                                 text:text
                        numberOfLines:1
                                 font:self.titleLabel.font
                        textAlignment:self.titleLabel.textAlignment
                        lineBreakMode:self.titleLabel.lineBreakMode
                   minimumScaleFactor:0
                         shadowOffset:CGSizeZero].width;
    }
        
        return 0;
}

- (CGFloat)m_textHeightForState:(UIControlState)state {
    CGFloat maxWidth = self.titleLabel.preferredMaxLayoutWidth;
    if (maxWidth == 0) {
        if (self.m_maxLayoutWidthEqualWidth) {
            maxWidth = CGRectGetWidth(self.frame);
        } else {
            maxWidth = CGFLOAT_MAX;
        }
    }
    
    NSAttributedString *attributedText = [self attributedTitleForState:state];
    if (attributedText) {
        return [MAGUITools calcTextSize:CGSizeMake(maxWidth, 30.0)
                                 text:attributedText
                        numberOfLines:self.titleLabel.numberOfLines
                                 font:nil
                        textAlignment:attributedText.alignment
                        lineBreakMode:attributedText.lineBreakMode
                   minimumScaleFactor:0
                         shadowOffset:CGSizeZero].height;
    }
    
    NSString *text = [self titleForState:state];
    if (text) {
        return [MAGUITools calcTextSize:CGSizeMake(maxWidth, 30.0)
                                 text:text
                        numberOfLines:self.titleLabel.numberOfLines
                                 font:self.titleLabel.font
                        textAlignment:self.titleLabel.textAlignment
                        lineBreakMode:self.titleLabel.lineBreakMode
                   minimumScaleFactor:0
                         shadowOffset:CGSizeZero].height;
    }
    
    return 0;
}

- (CGSize)m_textSizeForState:(UIControlState)state {
    NSAttributedString *attributedText = [self attributedTitleForState:state];
    CGFloat maxWidth = self.titleLabel.preferredMaxLayoutWidth;
    if (maxWidth == 0) maxWidth = CGFLOAT_MAX;
    
    if (attributedText) {
        return [MAGUITools calcTextSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                 text:attributedText
                        numberOfLines:self.titleLabel.numberOfLines
                                 font:nil
                        textAlignment:attributedText.alignment
                        lineBreakMode:attributedText.lineBreakMode
                   minimumScaleFactor:0
                         shadowOffset:CGSizeZero];
    }
    
    NSString *text = [self titleForState:state];
    if (text) {
        return [MAGUITools calcTextSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                 text:text
                        numberOfLines:self.titleLabel.numberOfLines
                                 font:self.titleLabel.font
                        textAlignment:self.titleLabel.textAlignment
                        lineBreakMode:self.titleLabel.lineBreakMode
                   minimumScaleFactor:0
                         shadowOffset:CGSizeZero];
    }
    
    return CGSizeZero;
}


- (void)setM_maxLayoutWidthEqualWidth:(BOOL)m_maxLayoutWidthEqualWidth {
    [self setAssociateWeakValue:@(m_maxLayoutWidthEqualWidth) withKey:@selector(m_maxLayoutWidthEqualWidth)];
}

- (BOOL)m_maxLayoutWidthEqualWidth {
    return [[self getAssociatedValueForKey:@selector(m_maxLayoutWidthEqualWidth)] boolValue];
}

- (void)setM_cornerRadius:(CGFloat)m_cornerRadius {
    [self setAssociateValue:@(m_cornerRadius) withKey:@selector(m_cornerRadius)];
    if ([self isMemberOfClass:MAGButton.class]) {    
        [self setNeedsLayout];
    }
}

- (CGFloat)m_cornerRadius {
    return [[self getAssociatedValueForKey:@selector(m_cornerRadius)] floatValue];
}

@end

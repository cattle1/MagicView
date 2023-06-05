//
//  YYLabel+Magic.m
//  MagicView
//
//  Created by LL on 2021/7/9.
//

#import "YYLabel+Magic.h"

#import "MAGUITools.h"

@implementation YYLabel (Magic)

- (CGFloat)m_textWidth {
    if (self.attributedText) {
        return [MAGUITools calcTextSize:CGSizeMake(CGFLOAT_MAX, 30.0)
                                 text:self.attributedText
                        numberOfLines:1
                                 font:nil
                        textAlignment:self.attributedText.alignment
                        lineBreakMode:self.attributedText.lineBreakMode
                   minimumScaleFactor:0
                         shadowOffset:CGSizeZero].width;
    }
    
    return [MAGUITools calcTextSize:CGSizeMake(CGFLOAT_MAX, 30.0)
                             text:self.text
                    numberOfLines:1
                             font:self.font
                    textAlignment:self.textAlignment
                    lineBreakMode:self.lineBreakMode
               minimumScaleFactor:0
                     shadowOffset:CGSizeZero].width;
}

- (CGFloat)m_textHeight {
    CGFloat maxWidth = self.preferredMaxLayoutWidth;
    if (maxWidth == 0) {
        if (self.m_maxLayoutWidthEqualWidth) {
            maxWidth = CGRectGetWidth(self.frame);
        } else {
            maxWidth = CGFLOAT_MAX;
        }
    }
    
    if (self.attributedText) {
        return [MAGUITools calcTextSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                 text:self.attributedText
                        numberOfLines:self.numberOfLines
                                 font:nil
                        textAlignment:self.attributedText.alignment
                        lineBreakMode:self.attributedText.lineBreakMode
                   minimumScaleFactor:0
                         shadowOffset:CGSizeZero].height;
    }
    
    return [MAGUITools calcTextSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                             text:self.text
                    numberOfLines:self.numberOfLines
                             font:self.font
                    textAlignment:self.textAlignment
                    lineBreakMode:self.lineBreakMode
               minimumScaleFactor:0
                     shadowOffset:CGSizeZero].height;
}

- (CGSize)m_textSize {
    CGFloat maxWidth = CGFLOAT_MAX;
    if (self.preferredMaxLayoutWidth > 0) {
        maxWidth = self.preferredMaxLayoutWidth;
    }
    
    if (self.attributedText) {
        return [MAGUITools calcTextSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                 text:self.attributedText
                        numberOfLines:self.numberOfLines
                                 font:nil
                        textAlignment:self.attributedText.alignment
                        lineBreakMode:self.attributedText.lineBreakMode
                   minimumScaleFactor:0
                         shadowOffset:CGSizeZero];
    }
    
    return [MAGUITools calcTextSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                             text:self.text
                    numberOfLines:self.numberOfLines
                             font:self.font
                    textAlignment:self.textAlignment
                    lineBreakMode:self.lineBreakMode
               minimumScaleFactor:0
                     shadowOffset:CGSizeZero];
}


#pragma mark - Setter/Getter
- (void)setM_maxLayoutWidthEqualWidth:(BOOL)m_maxLayoutWidthEqualWidth {
    [self setAssociateWeakValue:@(m_maxLayoutWidthEqualWidth) withKey:@selector(m_maxLayoutWidthEqualWidth)];
}

- (BOOL)m_maxLayoutWidthEqualWidth {
    return [[self getAssociatedValueForKey:@selector(m_maxLayoutWidthEqualWidth)] boolValue];
}

@end

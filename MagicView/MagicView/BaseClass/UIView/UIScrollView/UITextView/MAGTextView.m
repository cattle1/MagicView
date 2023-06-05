//
//  MAGTextView.m
//  MagicView
//
//  Created by LL on 2021/9/7.
//

#import "MAGTextView.h"

@implementation MAGTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    if (self = [super initWithFrame:frame textContainer:textContainer]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [mNotificationCenter addObserver:self selector:@selector(textDidChangeNotification) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsDisplay];
    !self.m_frameBlock ?: self.m_frameBlock(self);
}

- (void)drawRect:(CGRect)rect {
    if (self.text.length > 0) return;
    if (self.m_placeholderAttributedText == nil) return;
    
    
    UIEdgeInsets inset = self.textContainerInset;
    inset.left += 5.0;
    inset.right += 5.0;
    
    [self.m_placeholderAttributedText drawInRect:UIEdgeInsetsInsetRect(rect, inset)];
}


#pragma mark - Notification
- (void)textDidChangeNotification {
    if (self.m_placeholderAttributedText) {
        [self setNeedsDisplay];
    }
}

@end

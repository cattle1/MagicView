//
//  MAGBookReaderSetting.m
//  MagicView
//
//  Created by LL on 2021/7/16.
//

#import "MAGBookReaderManager.h"

#import "MAGImport.h"

static MBookReaderAnimate _bookReaderAnimate;
static MBookReaderBackgroundStyle _bookReaderBackgroundStyle;
static UIColor *_bookReaderTextColor;
static UIImage *_bookReaderBackgroundImage;
static UIFont *_bookReaderTextFont;
static CGFloat _bookReaderTextFontSize;

@implementation MAGBookReaderManager

+ (void)initialize {
    NSString *bookReaderAnimateIdentifier = [mUserDefault objectForKey:mBookReaderAnimateStyleKey];
    if (bookReaderAnimateIdentifier) {
        _bookReaderAnimate = [bookReaderAnimateIdentifier integerValue];
    } else {
        _bookReaderAnimate = mBookReaderDefaultAnimate;
    }
    
    NSString *bookReaderBackgroundIdentifier = [mUserDefault objectForKey:mBookReaderBackgroundImageStyleKey];
    if (bookReaderBackgroundIdentifier) {
        _bookReaderBackgroundStyle =  [bookReaderBackgroundIdentifier integerValue];
    } else {
        _bookReaderBackgroundStyle = mBookReaderBackgroundDefaultStyle;
    }
    
    NSString *bookReaderTextFontSizeIdentifier = [mUserDefault objectForKey:mBookReaderTextFontSizeKey];
    if (bookReaderTextFontSizeIdentifier) {
        _bookReaderTextFontSize = [bookReaderTextFontSizeIdentifier floatValue];
    } else {
        _bookReaderTextFontSize = 22.0;
    }
}

+ (void)setReaderAnimate:(MBookReaderAnimate)animate {
    _bookReaderAnimate = animate;
    
    [mUserDefault setObject:mNSStringFromInteger(animate) forKey:mBookReaderAnimateStyleKey];
    [mNotificationCenter postNotificationName:MAGBookReaderAnimateDidChangeNotification object:nil];
}

+ (MBookReaderAnimate)readerAnimate {
    return _bookReaderAnimate;
}

+ (void)setReaderBackgroundStyle:(MBookReaderBackgroundStyle)bookReaderBackgroundStyle {
    _bookReaderBackgroundStyle = bookReaderBackgroundStyle;
    
    _bookReaderBackgroundImage = nil;
    _bookReaderTextColor = nil;
    [mUserDefault setObject:mNSStringFromInteger(bookReaderBackgroundStyle) forKey:mBookReaderBackgroundImageStyleKey];
    [mNotificationCenter postNotificationName:MAGBookReaderBackgroundImageDidChangeNotification object:nil];
}

+ (MBookReaderBackgroundStyle)readerBackgroundStyle {
    return _bookReaderBackgroundStyle;
}

+ (UIImage *)readerBackgroundImage {
    if (_bookReaderBackgroundImage) {
        return _bookReaderBackgroundImage;
    }
    
    switch (_bookReaderBackgroundStyle) {
        case MBookReaderBackgroundStyleWhite:
        {
            _bookReaderBackgroundImage = [UIImage imageWithColor:mColorRGB(255, 255, 255)];
        }
            break;
        case MBookReaderBackgroundStyleGray:
        {
            _bookReaderBackgroundImage = [UIImage imageWithColor:mColorRGB(234, 234, 239)];
        }
            break;
        case MBookReaderBackgroundStyleBlack:
        {
            _bookReaderBackgroundImage = [UIImage imageWithColor:mColorRGB(24, 24, 24)];
        }
            break;
        case MBookReaderBackgroundStyleKraftPaper:
        {
            _bookReaderBackgroundImage = [UIImage imageWithColor:mColorRGB(199, 164, 124)];
        }
            break;
        case MBookReaderBackgroundStyleYellow:
        {
            _bookReaderBackgroundImage = [UIImage imageWithColor:mColorRGB(250, 249, 222)];
        }
            break;
        case MBookReaderBackgroundStyleBrown:
        {
            _bookReaderBackgroundImage = [UIImage imageWithColor:mColorRGB(255, 242, 226)];
        }
            break;
        case MBookReaderBackgroundStyleRed:
        {
            _bookReaderBackgroundImage = [UIImage imageWithColor:mColorRGB(253, 230, 224)];
        }
            break;
        case MBookReaderBackgroundStyleGreen:
        {
            _bookReaderBackgroundImage = [UIImage imageWithColor:mColorRGB(227, 237, 205)];
        }
            break;
        case MBookReaderBackgroundStyleBlue:
        {
            _bookReaderBackgroundImage = [UIImage imageWithColor:mColorRGB(220, 226, 241)];
        }
            break;
        case MBookReaderBackgroundStylePurple:
        {
            _bookReaderBackgroundImage = [UIImage imageWithColor:mColorRGB(233, 235, 254)];
        }
            break;
    }
    
    return _bookReaderBackgroundImage;
}

+ (UIColor *)readerTextColor {
    if (_bookReaderTextColor) {
        return _bookReaderTextColor;
    }
    
    switch (_bookReaderBackgroundStyle) {
        case MBookReaderBackgroundStyleBlack:
        {
            _bookReaderTextColor = mColorRGB(255, 255, 255);
        }
            break;
        default:
        {
            _bookReaderTextColor = mColorRGB(57, 56, 60);
        }
            break;
    }
    
    return _bookReaderTextColor;
}

+ (UIFont *)readerTextFont {
    if (_bookReaderTextFont == nil) {
        _bookReaderTextFont = [UIFont systemFontOfSize:_bookReaderTextFontSize];
    }
    return _bookReaderTextFont;
}

+ (UIFont *)readerTitleFont {
    return [[self readerTextFont] fontWithSize:[self readerTextSize] + 3.0];
}

+ (void)setReaderTextSize:(CGFloat)bookReaderTextFontSize {
    _bookReaderTextFontSize = bookReaderTextFontSize;
    
    [mUserDefault setObject:mNSStringFromFloat(bookReaderTextFontSize) forKey:mBookReaderTextFontSizeKey];
    [mNotificationCenter postNotificationName:MAGBookReaderTextFontSizeDidChangeNotification object:nil];
}

+ (CGFloat)readerTextSize {
    return _bookReaderTextFontSize;
}

+ (CGFloat)lineSpacing {
    return 5.0;
}

+ (CGRect)readerFrame {
    static CGRect _readerViewFrame;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (mThirdPartyAdSwith) {
            _readerViewFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - MAGBookReaderManager.bottomADHeight);
        } else {
            _readerViewFrame = (CGRect){.size = kScreenSize};
        }
    });
    return _readerViewFrame;
}

+ (CGFloat)bottomADHeight {
    static CGFloat _bottomADHeight = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bottomADHeight = 45.0;
        if (mBUASwitch) {
            _bottomADHeight = mGeometricValue(kScreenWidth, 90, 600);
        }
    });
    return _bottomADHeight;
}

+ (CGFloat)readerTopHeight {
    static CGFloat _readerTopHeight;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _readerTopHeight = mSafeAreaInsertTop + 20.0f + 20.0f;
    });
    return _readerTopHeight;
}

+ (CGFloat)readerBottomHeight {
    static CGFloat _readerBottomHeight;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _readerBottomHeight = mSafeAreaInsertBottom + 20.0f + 20.0f;
        if (mThirdPartyAdSwith) {
            _readerBottomHeight -= mSafeAreaInsertBottom;
        }
    });
    return _readerBottomHeight;
}

+ (CGRect)bookContentFrame {
    static CGRect _bookContentFrame;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bookContentFrame = CGRectMake(mHalfMargin, self.readerTopHeight, kScreenWidth - 2 * mHalfMargin, kScreenHeight);
        if (mThirdPartyAdSwith) {
            _bookContentFrame.size.height = CGRectGetHeight(self.readerFrame) - CGRectGetMinY(_bookContentFrame) - self.readerBottomHeight;
        } else {
            _bookContentFrame.size.height = kScreenHeight - CGRectGetMinY(_bookContentFrame) - self.readerBottomHeight;
        }
    });
    return _bookContentFrame;
}

@end

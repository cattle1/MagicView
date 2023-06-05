//
//  MAGBookReaderMenuView1.m
//  MagicView
//
//  Created by LL on 2021/8/30.
//

#import "MAGBookReaderMenuView1.h"

@interface MAGBookReaderMenuView1 ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIImageView *listenImageView;

@end

@implementation MAGBookReaderMenuView1

- (void)createSubviews {
    [super createSubviews];
    
    self.bottomView.hidden = YES;
    [self.topView addSubview:self.backImageView];
    
    UIImageView *catalogImageView = [MAGUIFactory imageView];
    catalogImageView.image = mCatalogImage.m_renderingModeAlwaysTemplate;
    catalogImageView.tintColor = self.backImageView.tintColor;
    catalogImageView.frame = CGRectMake(CGRectGetMaxX(self.backImageView.frame) + mHalfMargin, 0, 21, 18);
    catalogImageView.centerY = self.backImageView.centerY;
    [catalogImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushBookCatalogViewController)]];
    [self.topView addSubview:catalogImageView];
    
    UIImageView *listenImageView = nil;
    if (mBackgroundAudioPlayback) {
        listenImageView = [MAGUIFactory imageView];
        self.listenImageView = listenImageView;
        self.listenImageView.image = mListenImage1.m_renderingModeAlwaysTemplate;
        listenImageView.tintColor = mBookReaderHighlightColor;
        listenImageView.frame = CGRectMake(kScreenWidth - 25.0 - 15.0, 0, 25.0, 25.0);
        listenImageView.centerY = catalogImageView.centerY;
        [listenImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startListening)]];
        [self.topView addSubview:listenImageView];
    }
    
    UILabel *titleLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mBoldFont17 textColor:MAGBookReaderManager.readerTextColor];
    self.titleLabel = titleLabel;
    titleLabel.frame = CGRectMake(CGRectGetMaxX(catalogImageView.frame) + mMoreHalfMargin, 0, 0, 24.0);
    if (listenImageView) {
        titleLabel.width = CGRectGetMinX(listenImageView.frame) - mMoreHalfMargin - CGRectGetMinX(titleLabel.frame);
    } else {
        titleLabel.width = kScreenWidth - mMoreHalfMargin - CGRectGetMinX(titleLabel.frame);
    }
    titleLabel.centerY = catalogImageView.centerY;
    [self.topView addSubview:titleLabel];
}

- (void)show {
    [super show];
    
    self.titleLabel.text = self.bookManager.readInfo.chapterTitle;
}

- (void)startListening {
    [super startListening];
    
    self.listenImageView.tintColor = self.backImageView.tintColor;
}


#pragma mark - MAGBookListenDelegate
- (void)listenBookDidFinishSpeechUtterance:(MAGBookListenManager *)listenManager {
    [super listenBookDidFinishSpeechUtterance:listenManager];
    self.listenImageView.tintColor = mBookReaderHighlightColor;
}

@end

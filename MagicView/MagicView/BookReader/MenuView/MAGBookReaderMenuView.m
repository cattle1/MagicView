//
//  MAGBookReaderMenuView.m
//  MagicView
//
//  Created by LL on 2021/8/30.
//

#import "MAGBookReaderMenuView.h"

#import "MAGViewController.h"
#import "MAGBookCatalogViewController.h"

#import "MAGBookReaderMenuView1.h"

@implementation MAGBookReaderMenuView

@synthesize listenManager = _listenManager;
@synthesize menuBackgroundColor = _menuBackgroundColor;
@synthesize menuTintColor = _menuTintColor;
@synthesize topView = _topView;
@synthesize bottomView = _bottomView;
@synthesize toolBar = _toolBar;
@synthesize backImageView = _backImageView;

- (void)dealloc {
    [_listenManager stopSpeaking];
}

+ (instancetype)menuViewWithBookManager:(MAGBookManager *)bookManager {
    MAGBookReaderMenuView *menuView = [[MAGBookReaderMenuView1 alloc] init];
    
    menuView->_bookManager = bookManager;
    return menuView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self mp_initialize];
    }
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        MAGViewController *viewController = (MAGViewController *)self.viewController;
        [viewController setStatusBarHidden:NO];
        [viewController setCanSlidingBack:YES];
        
        if (MAGBookReaderManager.readerBackgroundStyle == MBookReaderBackgroundStyleBlack) {
            [viewController setStatusBarLightStyle];
        } else {
            [viewController setStatusBarDarkStyle];
        }
    }];
    
    [MAGClickAgent event:@"用户点击展示小说菜单栏" attributes:self.clickAttributes];
}

- (void)hide {
    self.alpha = 0.0;
    self.toolBar.hidden = YES;
    MAGViewController *viewController = (MAGViewController *)self.viewController;
    [viewController setStatusBarHidden:YES];
    [viewController setCanSlidingBack:NO];
    
    [MAGClickAgent event:@"用户点击隐藏小说菜单栏" attributes:self.clickAttributes];
}

- (BOOL)isShow {
    return (self.alpha == 1 && !self.isHidden);
}

- (void)startListening {
    self.toolBar.hidden = YES;
    
    if (self.listenManager.isSpeaking) {
        [self.listenManager stopSpeaking];
        [MAGClickAgent event:@"用户停止听书" attributes:self.clickAttributes];
    } else {
        self.listenManager.chapterIndex = self.bookManager.readInfo.chapterIndex;
        self.listenManager.startIndex = self.bookManager.readInfo.pageIndex;
        self.listenManager.strings = self.bookManager.listenStrings;
        [self.listenManager startSpeaking];
        [MAGClickAgent event:@"用户开始听书" attributes:self.clickAttributes];
    }
    
    [self hide];
}

- (void)pushBookCatalogViewController {
    MAGBookCatalogViewController *viewController = [MAGBookCatalogViewController catalogViewControllerWithBookID:self.bookManager.bookID];
    viewController.switchChapterBlock = self.switchChapterBlock;
    [self.viewController.navigationController pushViewController:viewController animated:YES];
    [self hide];    
}

- (void)m_popViewController {
    [self.viewController m_popViewController];
    
    [MAGClickAgent event:@"用户点击了小说阅读器返回按钮" attributes:self.clickAttributes];
}


#pragma mark - Private
- (void)mp_initialize {
    self.alpha = 0.0;
    self.frame = (CGRect){.size = kScreenSize};
    self.backgroundColor = mClearColor;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    
    [mNotificationCenter addObserver:self selector:@selector(backgroundImageDidChangeNotification) name:MAGBookReaderBackgroundImageDidChangeNotification object:nil];
}


#pragma mark - MAGBookListenDelegate
- (void)listenBookDidStartSpeechUtterance:(MAGBookListenManager *)listenManager {}

- (void)listenBookDidStartNewSpeechUtterance:(MAGBookListenManager *)listenManager chapterIndex:(NSInteger)chapterIndex pageIndex:(NSInteger)pageIndex {
    !self.listenDidStartNewSpeechUtterance ?: self.listenDidStartNewSpeechUtterance(chapterIndex, pageIndex);
}

- (void)listenBookDidFinishSpeechUtterance:(MAGBookListenManager *)listenManager {
    !self.listenBookDidFinishSpeechUtterance ?: self.listenBookDidFinishSpeechUtterance();
}

- (void)listenBookDidPauseSpeechUtterance:(MAGBookListenManager *)listenManager {}

- (void)listenBookDidContinueSpeechUtterance:(MAGBookListenManager *)listenManager {}

- (void)listenBookDidCancelSpeechUtterance:(MAGBookListenManager *)listenManager {}

- (void)listenBook:(MAGBookListenManager *)listenManager willSpeakRangeOfSpeechString:(NSRange)characterRange pageIndex:(NSInteger)pageIndex chapterIndex:(NSInteger)chapterIndex {
    !self.listenWillSpeakRangeOfSpeechString ?: self.listenWillSpeakRangeOfSpeechString(chapterIndex, pageIndex, characterRange);
}


#pragma mark - Getter
- (UIColor *)menuBackgroundColor {
    if (_menuBackgroundColor == nil) {
        _menuBackgroundColor = [UIColor colorWithPatternImage:MAGBookReaderManager.readerBackgroundImage];
    }
    return _menuBackgroundColor;
}

- (UIColor *)menuTintColor {
    if (_menuTintColor == nil) {
        _menuTintColor = MAGBookReaderManager.readerTextColor;
    }
    return _menuTintColor;
}

- (MAGBookListenManager *)listenManager {
    if (_listenManager == nil) {
        _listenManager = [MAGBookListenManager shareInstance];
        _listenManager.delegate = self;
    }
    return _listenManager;
}

- (UIView *)topView {
    if (_topView == nil) {
        _topView = [MAGUIFactory viewWithBackgroundColor:self.menuBackgroundColor cornerRadius:0.0];
        _topView.frame = CGRectMake(0, 0, kScreenWidth, mSafeAreaInsertTop + 44.0);
        [self addSubview:_topView];
    }
    return _topView;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [MAGUIFactory viewWithBackgroundColor:self.menuBackgroundColor cornerRadius:0.0];
        _bottomView.frame = CGRectMake(0, 0, kScreenWidth, mSafeAreaInsertBottom + 44.0);
        _bottomView.top = kScreenHeight - CGRectGetHeight(_bottomView.frame);
        [self addSubview:_bottomView];
    }
    return _bottomView;
}

- (UIView *)toolBar {
    if (_toolBar == nil) {
        _toolBar = [MAGUIFactory viewWithBackgroundColor:self.menuBackgroundColor cornerRadius:0.0];
        _toolBar.frame = CGRectMake(0, 0, kScreenWidth, 44.0);
        _toolBar.hidden = YES;
        _toolBar.top = CGRectGetMinY(self.bottomView.frame) - CGRectGetHeight(_toolBar.frame);
        [self addSubview:_toolBar];
    }
    return _toolBar;
}

- (UIImageView *)backImageView {
    if (_backImageView == nil) {
        _backImageView = [MAGUIFactory imageView];
        _backImageView.image = mBackwardImage.m_renderingModeAlwaysTemplate;
        _backImageView.tintColor = MAGBookReaderManager.readerTextColor;
        _backImageView.frame = CGRectMake(mMoreHalfMargin, 0, mMoreHalfMargin, mMoreHalfMargin);
        _backImageView.top = mSafeAreaInsertTop + (mNavBarSafeAreaHeight - _backImageView.height) / 2.0;
        [_backImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(m_popViewController)]];
    }
    return _backImageView;
}

- (NSDictionary *)clickAttributes {
    return @{@"book_id" : self.bookManager.readInfo.bookID ?: @"NULL", @"chapter_index" : @(self.bookManager.readInfo.chapterIndex), @"page_index" : @(self.bookManager.readInfo.pageIndex), @"book_name" : self.bookManager.bookName ?: @"NULL"};
}


#pragma mark - Notification
- (void)backgroundImageDidChangeNotification {
    self->_menuBackgroundColor = nil;
    self->_menuTintColor = nil;
}

@end

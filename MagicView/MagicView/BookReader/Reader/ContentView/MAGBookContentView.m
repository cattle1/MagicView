//
//  MAGBookContentView.m
//  MagicView
//
//  Created by LL on 2021/7/16.
//

#import "MAGBookContentView.h"

#import "MAGBookContentView1.h"
#import "MAGBookBuyView.h"
#import "MAGBookRetryView.h"
#import "MAGActivityIndicatorView.h"

@interface MAGBookContentView ()

@property (nonatomic, weak) MAGActivityIndicatorView *loadingView;

@property (nonatomic, weak) UIImageView *backgroundImageView;

@property (nonatomic, weak) MAGBookBuyView *buyView;

@property (nonatomic, weak) MAGBookRetryView *retryView;

@end

@implementation MAGBookContentView

+ (instancetype)bookContentViewWithPageContent:(nullable MAGBookPageContentModel *)pageContent
                             bookManager:(nullable MAGBookManager *)bookManager
                              autoUpdate:(BOOL)autoUpdate {
    MAGBookContentView *contentView = [[MAGBookContentView1 alloc] init];
    contentView.pageContent = pageContent;
    contentView->_bookManager = bookManager;
    contentView->_autoUpdate = autoUpdate;
    
    return contentView;
}

- (void)initialize {
    [super initialize];
    
    self.frame = MAGBookReaderManager.readerFrame;
    self.backgroundColor = mClearColor;
    
    [mNotificationCenter addObserver:self selector:@selector(backgroundImageDidChangeNotification) name:MAGBookReaderBackgroundImageDidChangeNotification object:nil];
}

- (void)createSubviews {
    [super createSubviews];
    
    UIImageView *backgroundImageView = [MAGUIFactory imageViewWithBackgroundColor:nil image:[MAGBookReaderManager readerBackgroundImage] cornerRadius:0];
    self.backgroundImageView = backgroundImageView;
    backgroundImageView.frame = self.bounds;
    [self addSubview:backgroundImageView];
    
    YYTextView *contentView = [MAGUIFactory yyTextView];
    _contentView = contentView;
    contentView.frame = MAGBookReaderManager.bookContentFrame;
    contentView.editable = NO;
    contentView.selectable = NO;
    contentView.scrollEnabled = NO;
    [self addSubview:contentView];
    
    UIView *topView = [MAGUIFactory view];
    _topView = topView;
    topView.hidden = YES;
    topView.frame = CGRectMake(0, 0, kScreenWidth, MAGBookReaderManager.readerTopHeight);
    [self addSubview:topView];
    
    UIView *bottomView = [MAGUIFactory view];
    _bottomView = bottomView;
    bottomView.hidden = YES;
    bottomView.frame = CGRectMake(0, CGRectGetMaxY(contentView.frame), kScreenWidth, MAGBookReaderManager.readerBottomHeight);
    [self addSubview:bottomView];
    
    MAGBookBuyView *buyView = [MAGBookBuyView buyViewWithPageContent:self.pageContent];
    self.buyView = buyView;
    buyView.frame = self.bounds;
    [self addSubview:buyView];
    
    MAGBookRetryView *retryView = [[MAGBookRetryView alloc] init];
    self.retryView = retryView;
    retryView.frame = self.bounds;
    retryView.hidden = YES;
    [self addSubview:retryView];
    
    MAGActivityIndicatorView *loadingView = [MAGActivityIndicatorView activityIndicatorWithColor:MAGBookReaderManager.readerTextColor];
    self.loadingView = loadingView;
    loadingView.frame = CGRectMake(0, 0, 50.0, 50.0);
    loadingView.center = self.center;
    [loadingView startAnimating];
    [self addSubview:loadingView];
    
    if (self.pageContent) {
        self.pageContent = self.pageContent;
    }
}

- (void)didMoveToWindow {
    [super didMoveToWindow];

    [self mp_updateReadInfo];
}

- (void)speakRangeOfSpeechRange:(NSRange)characterRange chapterIndex:(NSInteger)chapterIndex pageIndex:(NSInteger)pageIndex {
    if (chapterIndex != self.pageContent.chapterIndex) return;
    if (pageIndex != self.pageContent.pageIndex) return;
    
    NSMutableAttributedString *pageAttributedString = [self.pageContent.attributedString mutableCopy];
    [pageAttributedString setBackgroundColor:mBookReaderHighlightColor range:characterRange];
    pageAttributedString.color = MAGBookReaderManager.readerTextColor;
    self->_contentView.attributedText = pageAttributedString;
}

- (void)didFinishSpeechUtterance {
    NSMutableAttributedString *pageAttributedString = [self.pageContent.attributedString mutableCopy];
    [pageAttributedString setBackgroundColor:UIColor.clearColor];
    pageAttributedString.color = MAGBookReaderManager.readerTextColor;
    self->_contentView.attributedText = pageAttributedString;
}

- (void)setPageContent:(MAGBookPageContentModel *)pageContent {
    _pageContent = pageContent;

    [self mp_updateReadInfo];

    if ([pageContent.content isEqualToString:mBookNoDataIdentifier]) {
        self.retryView.pageContent = pageContent;
        self.retryView.hidden = NO;
        
        [MAGClickAgent event:@"小说加载失败" attributes:@{@"book_id" : pageContent.bookID ?: @"NULL", @"chapter_index" : @(pageContent.chapterIndex)}];
    } else {
        NSMutableAttributedString *mutableAttributedString = [pageContent.attributedString mutableCopy];
        mutableAttributedString.color = MAGBookReaderManager.readerTextColor;
        self->_contentView.attributedText = mutableAttributedString;
        
        self.buyView.pageContent = pageContent;
        _topView.hidden = (pageContent == nil);
        _bottomView.hidden = (pageContent == nil);
        self.retryView.hidden = YES;
    }
    
    if (pageContent) {
        [self.loadingView stopAnimating];
        [self.loadingView removeFromSuperview];
    }
}


#pragma mark - Notification
- (void)backgroundImageDidChangeNotification {
    self.backgroundImageView.image = MAGBookReaderManager.readerBackgroundImage;
    
    NSMutableAttributedString *mutableAttributedString = [self.pageContent.attributedString mutableCopy];
    mutableAttributedString.color = MAGBookReaderManager.readerTextColor;
    self->_contentView.attributedText = mutableAttributedString;
}


#pragma mark - Private
/// 当页面显示并且有内容时更新阅读记录
- (void)mp_updateReadInfo {
    if (!self.autoUpdate) return;
    if (self->_bookManager == nil) return;
    
    if (self.window && self.pageContent) {
        if (![self->_bookManager.readInfo.chapterID isEqualToString:self.pageContent.chapterID]) {
            self->_bookManager.readInfo.chapterID = self.pageContent.chapterID;
        }
        if (self->_bookManager.readInfo.chapterIndex != self.pageContent.chapterIndex) {
            self->_bookManager.readInfo.chapterIndex = self.pageContent.chapterIndex;
        }
        if (![self->_bookManager.readInfo.chapterTitle isEqualToString:self.pageContent.chapterTitle]) {
            self->_bookManager.readInfo.chapterTitle = self.pageContent.chapterTitle;
        }
        if (![self->_bookManager.readInfo.pageContent isEqualToString:self.pageContent.content]) {
            self->_bookManager.readInfo.pageContent = self.pageContent.content;
        }
        if (self->_bookManager.readInfo.chapterPages != self.pageContent.chapterPages) {
            self->_bookManager.readInfo.chapterPages = self.pageContent.chapterPages;
        }
        if (self->_bookManager.readInfo.pageIndex != self.pageContent.pageIndex) {
            self->_bookManager.readInfo.pageIndex = self.pageContent.pageIndex;
        }
    }
}

@end

//
//  MAGBookAnimateViewController.m
//  MagicView
//
//  Created by LL on 2021/7/16.
//

#import "MAGBookAnimateViewController.h"

#import "MAGBookSimulationPageAnimateViewController.h"

@implementation MAGBookAnimateViewController

@synthesize bookManager = _bookManager;

+ (instancetype)bookReaderWithAnimate:(MBookReaderAnimate)animate
                               bookID:(NSString *)bookID
                            chapterID:(NSString *)chapterID
                         chapterIndex:(NSInteger)chapterIndex {
    MAGBookAnimateViewController *animateViewController;
    switch (animate) {
        case MBookReaderAnimateHorizontalPageCurl: {
            animateViewController = [[MAGBookSimulationPageAnimateViewController alloc] init];
        }
            break;
    }
    
    animateViewController->_bookID = [bookID copy];
    animateViewController->_chapterID = [chapterID copy];
    animateViewController->_chapterIndex = chapterIndex;
    
    return animateViewController;
}

- (void)initialize {
    [super initialize];
    
    self.view.frame = MAGBookReaderManager.readerFrame;
    [self setNavigationBarHidden:YES];
    
    [mNotificationCenter addObserver:self selector:@selector(backgroundImageDidChangeNotification) name:MAGBookReaderBackgroundImageDidChangeNotification object:nil];
    [mNotificationCenter addObserver:self selector:@selector(refreshBookReaderNotification) name:MAGBookReaderNeedRefreshNotification object:self.bookID.deepCopy];
    [mNotificationCenter addObserver:self selector:@selector(refreshBookReaderNotification) name:MAGUserPurchaseSuccessNotification object:nil];
}

- (void)createSubviews {
    [super createSubviews];
    
    UIImageView *backgroundImageView = [MAGUIFactory imageViewWithBackgroundColor:UIColor.whiteColor
                                                                            image:[MAGBookReaderManager readerBackgroundImage]
                                                                     cornerRadius:0.0];
    self->_backgroundImageView = backgroundImageView;
    backgroundImageView.frame = self.view.bounds;
    [self.view addSubview:backgroundImageView];
}

- (void)cancelTurnPage {
    [self.bookManager cancelTurnPage];
}

- (BOOL)isFirstPage {
    return [self.bookManager isFirstPage];
}

- (BOOL)isLastPage {
    return [self.bookManager isLastPage];
}

- (void)getCurrentPageContent:(mBookPageContentBlock)block autoUpdate:(BOOL)autoUpdate {
    [self.bookManager getCurrentPageContent:block autoUpdate:autoUpdate];
}

- (void)getAfterPageContent:(mBookPageContentBlock)block autoUpdate:(BOOL)autoUpdate {
    [self.bookManager getAfterPageContent:block autoUpdate:autoUpdate];
}

- (void)getBeforePageContent:(mBookPageContentBlock)block autoUpdate:(BOOL)autoUpdate {
    [self.bookManager getBeforePageContent:block autoUpdate:autoUpdate];
}

- (void)getPageContentWithChapterIndex:(NSInteger)chapterIndex pageIndex:(NSInteger)pageIndex complte:(mBookPageContentBlock)block autoUpdate:(BOOL)autoUpdate {
    [self.bookManager getPageContentWithChapterIndex:chapterIndex pageIndex:pageIndex complte:block autoUpdate:autoUpdate];
}

- (void)getPageContentWithChapterID:(NSString *)chapterID pageIndex:(NSInteger)pageIndex complte:(mBookPageContentBlock)block autoUpdate:(BOOL)autoUpdate {
    [self.bookManager getPageContentWithChapterID:chapterID pageIndex:pageIndex complte:block autoUpdate:autoUpdate];
}

- (nullable MAGBookPageContentModel *)getCurrentPageContentWithAutoUpdate:(BOOL)autoUpdate {
    return [self.bookManager getCurrentPageContentWithAutoUpdate:autoUpdate];
}

- (nullable MAGBookPageContentModel *)getAfterPageContentWithAutoUpdate:(BOOL)autoUpdate {
    return [self.bookManager getAfterPageContentWithAutoUpdate:autoUpdate];
}

- (nullable MAGBookPageContentModel *)getBeforePageContentWithAutoUpdate:(BOOL)autoUpdate {
    return [self.bookManager getBeforePageContentWithAutoUpdate:autoUpdate];
}

- (nullable MAGBookPageContentModel *)getPageContentWithChapterID:(NSString *)chapterID pageIndex:(NSInteger)pageIndex autoUpdate:(BOOL)autoUpdate {
    return [self.bookManager getPageContentWithChapterID:chapterID pageIndex:pageIndex autoUpdate:autoUpdate];
}

- (nullable MAGBookPageContentModel *)getPageContentWithChapterIndex:(NSInteger)chapterIndex pageIndex:(NSInteger)pageIndex autoUpdate:(BOOL)autoUpdate {
    return [self.bookManager getPageContentWithChapterIndex:chapterIndex pageIndex:pageIndex autoUpdate:autoUpdate];
}

- (void)switchChapterWithChpaterID:(NSString *)chapterID {}

- (void)jumpToTheNextPage:(NSInteger)chapterIndex pageIndex:(NSInteger)pageIndex {}

- (void)speakRangeOfSpeechRange:(NSRange)characterRange chapterIndex:(NSInteger)chapterIndex pageIndex:(NSInteger)pageIndex {}

- (void)didFinishSpeechUtterance {}


#pragma mark - Getter
- (MAGBookManager *)bookManager {
    if (_bookManager == nil) {
        _bookManager = [MAGBookManager bookManagerWithBookID:self.bookID];
    }
    return _bookManager;
}

- (NSDictionary *)clickAttributeds {
    return @{@"book_id" : self.bookID ?: @"NULL", @"chapter_index" : @(self.bookManager.readInfo.chapterIndex), @"page_index" : @(self.bookManager.readInfo.pageIndex), @"book_name" : self.bookManager.bookName ?: @"NULL"};
    
}


#pragma mark - Notification
- (void)backgroundImageDidChangeNotification {
    self->_backgroundImageView.image = MAGBookReaderManager.readerBackgroundImage;
}

- (void)refreshBookReaderNotification {}

@end

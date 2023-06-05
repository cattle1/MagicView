//
//  MAGBookReaderViewController.m
//  MagicView
//
//  Created by LL on 2021/7/9.
//

#import "MAGBookReaderViewController.h"

#import "MAGBookRecordManager.h"
#import "MAGBookAnimateViewController.h"
#import "MAGBookReaderMenuView.h"
#import "MAGBookCatalogModel.h"
#import "MAGADView.h"

@interface MAGBookReaderViewController ()<MAGBookAnimateViewControllerDelegate, MAGNavigationControllerTransitionDelegate>

@property (nonatomic, copy) NSString *bookID;

@property (nonatomic, copy) NSString *chapterID;

@property (nonatomic, assign) NSInteger chapterIndex;

@property (nonatomic, assign) MBookReaderAnimate readAnimate;


@property (nonatomic, weak) MAGBookReaderMenuView *menuView;

@property (nonatomic, weak) MAGBookAnimateViewController *readerViewController;

@property (nonatomic, weak) MAGADView *adView;

@end

@implementation MAGBookReaderViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MAGClickAgent event:@"用户离开小说阅读器"];
}

- (instancetype)initWithBookID:(NSString *)bookID {
    return [self initWithBookID:bookID chapterIndex:-1];
}

- (instancetype)initWithBookID:(NSString *)bookID chapterID:(NSString *)chapterID {
    if (self = [super init]) {
        self->_bookID = [bookID copy] ?: @"";
        self->_chapterID = [chapterID copy];
        self->_chapterIndex = -1;
    }
    
    return self;
}

- (instancetype)initWithBookID:(NSString *)bookID chapterIndex:(NSUInteger)chapterIndex {    
    if (self = [super init]) {
        self->_bookID = [bookID copy] ?: @"";
        self->_chapterIndex = (NSInteger)chapterIndex;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setHomeIndicatorHidden:YES];
    [self setStatusBarHidden:!self.menuView.isShow];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 显示菜单栏时禁止侧滑返回
    if (!self.menuView.isShow) {   
        self.canSlidingBack = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self setHomeIndicatorHidden:NO];
    [self setStatusBarHidden:NO];
}


- (void)initialize {
    [super initialize];
    
    [self setNavigationBarHidden:YES];
    
    self.readAnimate = MAGBookReaderManager.readerAnimate;
    self.navigationController.delegate = self;
    
    [mNotificationCenter addObserver:self selector:@selector(backgroundImageDidChangeNotification) name:MAGBookReaderBackgroundImageDidChangeNotification object:nil];
    
    [MAGClickAgent event:@"用户进入小说阅读器" attributes:@{@"book_id" : self.bookID ?: @"NULL"}];
}

- (void)createSubviews {
    [super createSubviews];
    
    MAGBookAnimateViewController *readerViewController = [MAGBookAnimateViewController bookReaderWithAnimate:self.readAnimate
                                                                                                      bookID:self.bookID
                                                                                                   chapterID:self.chapterID
                                                                                                chapterIndex:self.chapterIndex];
    self.readerViewController = readerViewController;
    readerViewController.delegate = self;
    [self addChildViewController:readerViewController];
    [self.view addSubview:readerViewController.view];
    
    
    MAGBookReaderMenuView *menuView = [MAGBookReaderMenuView menuViewWithBookManager:readerViewController.bookManager];
    self.menuView = menuView;
    NSString *bookID = self.bookID ?: @"NULL";
    menuView.switchChapterBlock = ^(MAGBookCatalogListModel * _Nonnull catalogModel) {
        [readerViewController switchChapterWithChpaterID:catalogModel.chapterID];
        [MAGClickAgent event:[NSString stringWithFormat:@"用户跳转到小说第%zd章", catalogModel.realIndex] attributes:@{@"book_id" : bookID, @"chapter_id" : catalogModel.chapterID ?: @"NULL"}];
    };
    menuView.listenWillSpeakRangeOfSpeechString = ^(NSInteger chapterIndex, NSInteger pageIndex, NSRange characterRange) {
        [readerViewController speakRangeOfSpeechRange:characterRange chapterIndex:chapterIndex pageIndex:pageIndex];
    };
    menuView.listenDidStartNewSpeechUtterance = ^(NSInteger chapterIndex, NSInteger pageIndex) {
        [readerViewController jumpToTheNextPage:chapterIndex pageIndex:pageIndex];
    };
    menuView.listenBookDidFinishSpeechUtterance = ^{
        [readerViewController didFinishSpeechUtterance];
    };
    [self.view addSubview:menuView];
    
    MAGADView *adView = [MAGADView adView];
    self.adView = adView;
    adView.frame = CGRectMake(0, kScreenHeight - MAGBookReaderManager.bottomADHeight, kScreenWidth, MAGBookReaderManager.bottomADHeight);
    adView.backgroundColor = [UIColor colorWithPatternImage:MAGBookReaderManager.readerBackgroundImage];
    [self.view addSubview:adView];
}


#pragma mark - MAGBookAnimateViewControllerDelegate
- (void)bookAnimateViewControllerDidClickMenuView:(MAGBookAnimateViewController *)viewController {
    [self.menuView show];
}


#pragma mark - MAGNavigationControllerTransitionDelegate
- (void)navigationController:(MAGNavigationController *)navigationController poppingByInteractiveGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer isCancelled:(BOOL)isCancelled viewControllerWillDisappear:(UIViewController *)viewControllerWillDisappear viewControllerWillAppear:(UIViewController *)viewControllerWillAppear {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (!isCancelled) {
            [MAGClickAgent event:@"用户侧滑退出了小说阅读器" attributes:@{@"book_id" : self.bookID, @"chapter_index" : @(self.readerViewController.bookManager.readInfo.chapterIndex), @"page_index" :  @(self.readerViewController.bookManager.readInfo.pageIndex)}];
        }
    }
}


#pragma mark - NSNotification
- (void)backgroundImageDidChangeNotification {
    if (MAGBookReaderManager.readerBackgroundStyle == MBookReaderBackgroundStyleBlack) {
        [self setStatusBarLightStyle];
    } else {
        [self setStatusBarDarkStyle];
    }
    
    self.adView.backgroundColor = [UIColor colorWithPatternImage:MAGBookReaderManager.readerBackgroundImage];
}

@end

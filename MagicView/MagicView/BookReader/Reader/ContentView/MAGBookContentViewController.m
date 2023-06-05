//
//  MAGBookContentViewController.m
//  MagicView
//
//  Created by LL on 2021/7/16.
//

#import "MAGBookContentViewController.h"

#import "MAGBookContentView.h"
#import "MAGBookPageContentModel.h"

@interface MAGBookContentViewController ()

@property (nonatomic, weak) MAGBookContentView *contentView;

@property (nonatomic, weak, nullable) MAGBookManager *bookManager;

@property (nonatomic, assign) BOOL autoUpdate;

@end

@implementation MAGBookContentViewController

+ (instancetype)contentViewControllerWithAutoUpdate:(BOOL)autoUpdate
                                        pageContent:(nullable MAGBookPageContentModel *)pageContent
                                        bookManager:(MAGBookManager *)bookManager {
    MAGBookContentViewController *contentViewController = [[self alloc] init];
    if (contentViewController) {
        contentViewController.pageContent = pageContent;
        contentViewController.bookManager = bookManager;
        contentViewController.autoUpdate = autoUpdate;
    }
    return contentViewController;
}

- (void)initialize {
    [super initialize];
    
    self.view.backgroundColor = mClearColor;
    [self setNavigationBarHidden:YES];
}

- (void)createSubviews {
    [super createSubviews];

    MAGBookContentView *contentView = [MAGBookContentView bookContentViewWithPageContent:self.pageContent
                                                                       bookManager:self.bookManager
                                                                        autoUpdate:self.autoUpdate];
    self.contentView = contentView;
    [self.view addSubview:contentView];
}

+ (UIViewController *)bookBackViewControllerWithObj:(id)obj {
    UIViewController *bookBackViewController = [[UIViewController alloc] init];
    
    if ([obj isMemberOfClass:MAGBookPageContentModel.class]) {
        MAGBookContentView *contentView = [MAGBookContentView bookContentViewWithPageContent:(MAGBookPageContentModel *)obj bookManager:nil autoUpdate:NO];
        contentView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        [bookBackViewController.view addSubview:contentView];
        return bookBackViewController;
    }
    
    if ([obj isKindOfClass:UIViewController.class]) {
        UIView *contentView = [[(UIViewController *)obj view] snapshotViewAfterScreenUpdates:NO];
        contentView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        [bookBackViewController.view addSubview:contentView];
        return bookBackViewController;
    }
    
    bookBackViewController.view.backgroundColor = [UIColor colorWithPatternImage:MAGBookReaderManager.readerBackgroundImage];
    return bookBackViewController;
}

- (void)setPageContent:(MAGBookPageContentModel *)pageContent {
    _pageContent = pageContent;
    
    self.contentView.pageContent = pageContent;
}

- (void)speakRangeOfSpeechRange:(NSRange)characterRange chapterIndex:(NSInteger)chapterIndex pageIndex:(NSInteger)pageIndex {
    [self.contentView speakRangeOfSpeechRange:characterRange chapterIndex:chapterIndex pageIndex:pageIndex];
}

- (void)didFinishSpeechUtterance {
    [self.contentView didFinishSpeechUtterance];
}

@end

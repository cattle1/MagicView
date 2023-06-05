//
//  MAGBookHorizontalPageCurlViewController.m
//  MagicView
//
//  Created by LL on 2021/7/16.
//

#import "MAGBookSimulationPageAnimateViewController.h"

#import "MAGPageViewController.h"

static struct DelegateFlags {
    unsigned int doDidClickMenuView : 1;
}delegateFlag;

@interface MAGBookSimulationPageAnimateViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, weak) MAGPageViewController *pageViewController;

@end

@implementation MAGBookSimulationPageAnimateViewController

- (void)createSubviews {
    [super createSubviews];
    
    MAGPageViewController *pageViewController = [[MAGPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController = pageViewController;
    pageViewController.dataSource = self;
    pageViewController.delegate = self;
    pageViewController.doubleSided = YES;
    pageViewController.view.frame = self.view.bounds;
    [pageViewController.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBookReader:)]];
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    
    MAGBookContentViewController *contentViewController = [MAGBookContentViewController contentViewControllerWithAutoUpdate:NO pageContent:nil bookManager:nil];
    [pageViewController setViewControllers:@[contentViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    if (!mObjectIsEmpty(self->_chapterID)) {
        [self getPageContentWithChapterID:self->_chapterID pageIndex:0 complte:^(MAGBookPageContentModel * _Nullable pageContent) {
            contentViewController.pageContent = pageContent;
        } autoUpdate:YES];
        return;
    }
    
    if (self->_chapterIndex >= 0) {
        [self getPageContentWithChapterIndex:self->_chapterIndex pageIndex:0 complte:^(MAGBookPageContentModel * _Nullable pageContent) {
            contentViewController.pageContent = pageContent;
        } autoUpdate:YES];
        return;
    }
    
    [self getCurrentPageContent:^(MAGBookPageContentModel * _Nullable pageContent) {
        contentViewController.pageContent = pageContent;
    } autoUpdate:YES];
}

- (void)setDelegate:(id<MAGBookAnimateViewControllerDelegate>)delegate {
    [super setDelegate:delegate];
    
    delegateFlag.doDidClickMenuView = [delegate respondsToSelector:@selector(bookAnimateViewControllerDidClickMenuView:)];
}

- (void)clickBookReader:(UITapGestureRecognizer *)tap {
    CGPoint clickPoint = [tap locationInView:self.view];
    CGFloat effectiveWidth = CGRectGetWidth(self.view.bounds) / 3.0;
    
    // 点击了屏幕中间1/3区域
    if (clickPoint.x >= effectiveWidth && clickPoint.x <= effectiveWidth * 2) {
        if (delegateFlag.doDidClickMenuView) {
            [self.delegate bookAnimateViewControllerDidClickMenuView:self];
        }
        return;
    }

    // 点击了屏幕左边1/3区域
    if (clickPoint.x < effectiveWidth) {
        [self mp_jumpToThePreviousPage];
        [MAGClickAgent event:@"用户点击往后翻了一页小说" attributes:self.clickAttributeds];
        return;
    }

    // 点击了屏幕右边1/3区域
    [self mp_jumpToTheNextPage];
    [MAGClickAgent event:@"用户点击往前翻了一页小说" attributes:self.clickAttributeds];
}

#pragma mark - Override
- (void)jumpToTheNextPage:(NSInteger)chapterIndex pageIndex:(NSInteger)pageIndex {
    [super jumpToTheNextPage:chapterIndex pageIndex:pageIndex];
    
    if (self.bookManager.readInfo.chapterIndex != chapterIndex) return;
    if (self.bookManager.readInfo.pageIndex + 1 != pageIndex) return;
    
    [self mp_jumpToTheNextPage];
    
    [MAGClickAgent event:@"由听书自动触发翻到下一页" attributes:@{@"page_index" : @(pageIndex)}];
}

- (void)speakRangeOfSpeechRange:(NSRange)characterRange chapterIndex:(NSInteger)chapterIndex pageIndex:(NSInteger)pageIndex {
    [super speakRangeOfSpeechRange:characterRange chapterIndex:chapterIndex pageIndex:pageIndex];
    
    MAGBookContentViewController *contentViewController = self.pageViewController.viewControllers.firstObject;
    [contentViewController speakRangeOfSpeechRange:characterRange chapterIndex:chapterIndex pageIndex:pageIndex];
}

- (void)didFinishSpeechUtterance {
    [super didFinishSpeechUtterance];
    
    MAGBookContentViewController *contentViewController = self.pageViewController.viewControllers.firstObject;
    [contentViewController didFinishSpeechUtterance];
}

- (void)switchChapterWithChpaterID:(NSString *)chapterID {
    [super switchChapterWithChpaterID:chapterID];
    
    mWeakobj(self)
    [self getPageContentWithChapterID:chapterID pageIndex:0 complte:^(MAGBookPageContentModel * _Nullable pageContent) {
        MAGBookContentViewController *contentViewController = [MAGBookContentViewController contentViewControllerWithAutoUpdate:NO pageContent:pageContent bookManager:nil];
        [weak_self.pageViewController setViewControllers:@[contentViewController ?: [[UIViewController alloc] init]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    } autoUpdate:YES];
}


#pragma mark - Private
/// 跳转到下一页
- (void)mp_jumpToTheNextPage {
    if ([self isLastPage]) {
        [mMainWindow m_showErrorHUDFromText:@"没有下一页了"];
        return;
    }
    
    mWeakobj(self)
    [self getBeforePageContent:^(MAGBookPageContentModel * _Nullable pageContent) {
        MAGBookContentViewController *contentViewController = [MAGBookContentViewController contentViewControllerWithAutoUpdate:NO pageContent:pageContent bookManager:nil];
        UIViewController *backViewController = [MAGBookContentViewController bookBackViewControllerWithObj:contentViewController];
        [weak_self.pageViewController setViewControllers:@[contentViewController, backViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    } autoUpdate:YES];
}

/// 跳转到上一页
- (void)mp_jumpToThePreviousPage {
    if ([self isFirstPage]) {
        [mMainWindow m_showErrorHUDFromText:@"没有上一页了"];
        return;
    }
    
    mWeakobj(self)
    [self getAfterPageContent:^(MAGBookPageContentModel * _Nullable pageContent) {
        MAGBookContentViewController *contentViewController = [MAGBookContentViewController contentViewControllerWithAutoUpdate:NO pageContent:pageContent bookManager:nil];
        UIViewController *backViewController = [MAGBookContentViewController bookBackViewControllerWithObj:contentViewController];
        [weak_self.pageViewController setViewControllers:@[contentViewController, backViewController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    } autoUpdate:YES];
}


#pragma mark - UIPageViewControllerDataSource
/// 通知观察者用户往后翻页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[MAGBookContentViewController class]]) {
        return [MAGBookContentViewController bookBackViewControllerWithObj:[self getAfterPageContentWithAutoUpdate:NO]];
    }
    
    if ([self isFirstPage]) return nil;
    
    MAGBookContentViewController *contentViewController = [MAGBookContentViewController contentViewControllerWithAutoUpdate:YES pageContent:nil bookManager:self.bookManager];
    [self getAfterPageContent:^(MAGBookPageContentModel * _Nullable pageContent) {
        contentViewController.pageContent = pageContent;
    } autoUpdate:NO];
    [MAGClickAgent event:@"用户滑动往后翻了一页小说" attributes:self.clickAttributeds];
    return contentViewController;
}

/// 通知观察者用户往前翻页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[MAGBookContentViewController class]]) {
        return [MAGBookContentViewController bookBackViewControllerWithObj:viewController];
    }
    
    if (self.isLastPage) return nil;
        
    MAGBookContentViewController *contentViewController = [MAGBookContentViewController contentViewControllerWithAutoUpdate:YES pageContent:nil bookManager:self.bookManager];
    [self getBeforePageContent:^(MAGBookPageContentModel * _Nullable pageContent) {
        contentViewController.pageContent = pageContent;
    } autoUpdate:NO];
    [MAGClickAgent event:@"用户滑动往前翻了一页小说" attributes:self.clickAttributeds];
    return contentViewController;
}


#pragma mark - UIPageViewControllerDelegate
/// 当用户结束滚动或翻页时触发
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        [self cancelTurnPage];
        [MAGClickAgent event:@"用户取消了滑动翻页" attributes:self.clickAttributeds];
    }
}


#pragma mark - Notification
- (void)refreshBookReaderNotification {
    [super refreshBookReaderNotification];
    
    MAGBookContentViewController *contentViewController = self.pageViewController.viewControllers.firstObject;
    [self getCurrentPageContent:^(MAGBookPageContentModel * _Nullable pageContent) {
        contentViewController.pageContent = pageContent;
    } autoUpdate:YES];
}

@end

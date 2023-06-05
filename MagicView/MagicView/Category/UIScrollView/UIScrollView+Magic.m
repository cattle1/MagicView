//
//  UIScrollView+Magic.m
//  MagicView
//
//  Created by LL on 2021/9/22.
//

#import "UIScrollView+Magic.h"

#import "MAGRefreshSafeHeader.h"

#import "MAGImport.h"

@implementation UIScrollView (Magic)

- (MJRefreshNormalHeader *)m_addNormalHeaderRefreshWithRefreshingBlock:(void (^)(void))block {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        !block ?: block();
        [MAGClickAgent event:@"用户开始下拉刷新"];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉即可刷新..." forState:MJRefreshStateIdle];
    [header setTitle:@"释放即可刷新..." forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.textColor = mTextColor1;
    UIActivityIndicatorView *loadingView = header.loadingView;
    loadingView.color = mTextColor1;
    self.mj_header = header;
    return header;
}

- (MJRefreshNormalHeader *)m_addSafeHeaderRefreshWithRefreshingBlock:(void (^)(void))block {
    MAGRefreshSafeHeader *header = [MAGRefreshSafeHeader headerWithRefreshingBlock:^{
        !block ?: block();
        [MAGClickAgent event:@"用户开始下拉刷新"];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉即可刷新..." forState:MJRefreshStateIdle];
    [header setTitle:@"释放即可刷新..." forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.textColor = mTextColor1;
    header.loadingView.color = mTextColor1;
    self.mj_header = header;
    return header;
}

- (MJRefreshAutoNormalFooter *)m_addNormalFooterRefreshWithRefreshingBlock:(void (^)(void))block {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        !block ?: block();
        [MAGClickAgent event:@"用户开始上拉加载"];
    }];
    [footer setTitle:@"上拉加载更多..." forState:MJRefreshStateIdle];
    [footer setTitle:@"上拉加载更多..." forState:MJRefreshStatePulling];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多了..." forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = mTextColor1;
    UIActivityIndicatorView *loadingView = footer.loadingView;
    loadingView.color = mTextColor1;
    self.mj_footer = footer;
    return footer;
}

- (void)m_endRefreshing {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    [MAGClickAgent event:@"用户结束了上拉/下拉刷新"];
}

- (void)m_endRefreshingWithNoMoreData {
    [self.mj_footer endRefreshingWithNoMoreData];
    [MAGClickAgent event:@"用户结束刷新并且提示没有更多数据"];
}

- (void)m_resetNoMoreData {
    [self.mj_footer resetNoMoreData];
    [MAGClickAgent event:@"用户重置了没有更多数据的状态"];
}

@end

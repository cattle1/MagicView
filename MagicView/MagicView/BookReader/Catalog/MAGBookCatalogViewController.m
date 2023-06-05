//
//  MAGBookCatalogViewController.m
//  MagicView
//
//  Created by LL on 2021/10/23.
//

#import "MAGBookCatalogViewController.h"

#import "MAGBookCatalogViewController1.h"

@implementation MAGBookCatalogViewController

@synthesize readInfo = _readInfo;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [MAGClickAgent appendDidAppearViewControllerName:@"小说目录页面"];
    [MAGClickAgent event:@"用户进入小说目录页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MAGClickAgent event:@"用户离开小说目录页面"];
}

+ (instancetype)catalogViewControllerWithBookID:(NSString *)bookID {
    MAGBookCatalogViewController *viewController = [[MAGBookCatalogViewController1 alloc] init];;
    viewController->_bookID = [bookID copy];
    
    return viewController;
}

- (void)netRequest {
    [super netRequest];
    
    if (self.catalogModel) return;
    
    MAGProgressHUD *loadingHUD = [self.view m_showDarkHUDFromText:nil];
    mWeakobj(self)
    [self POST:mBookPaginationCatalogLink parameters:@{@"book_id" : self.bookID ?: @"", @"chapter_id" : self.readInfo.chapterID ?: @""} modelClass:MAGBookCatalogModel.class success:^(BOOL isSuccess, id  _Nullable t_model, BOOL isCache, MAGNetworkRequestModel * _Nonnull requestModel) {
        [loadingHUD hideAnimated:YES];
        if (isSuccess) {
            weak_self.catalogModel = t_model;
                        
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                [t_model m_writeToFile:[MAGFileManager bookCatalogFilePathWithBookID:weak_self.bookID]];
            });
        } else {
            [mMainWindow m_showErrorHUDFromText:requestModel.msg ?: @"加载失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [loadingHUD hideAnimated:YES];
        [mMainWindow m_showErrorHUDFromError:error];
    }];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [MAGClickAgent event:@"用户开始滚动小说目录"];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [MAGClickAgent event:@"用户停止滚动小说目录"];
}


#pragma mark - Getter
- (MAGBookReadModel *)readInfo {
    if (_readInfo == nil) {
        _readInfo = [MAGBookRecordManager readInfoWihthBookID:self.bookID];
    }
    return _readInfo;
}

- (MAGBookCatalogModel *)catalogModel {
    if (_catalogModel == nil) {
        NSDictionary *catalogDict = [NSDictionary m_dictionaryWithContentsOfFile:[MAGFileManager bookCatalogFilePathWithBookID:self.bookID]];
        if (catalogDict) {
            _catalogModel = [MAGBookCatalogModel modelWithDictionary:catalogDict];
        }
    }
    return _catalogModel;
}

@end

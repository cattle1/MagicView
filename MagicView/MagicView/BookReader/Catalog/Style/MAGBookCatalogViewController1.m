//
//  MAGBookCatalogViewController.m
//  MagicView
//
//  Created by LL on 2021/8/31.
//

#import "MAGBookCatalogViewController1.h"

#import "MAGBookCatalogTableViewCell1.h"

@implementation MAGBookCatalogViewController1

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setStatusBarLightStyle];
}

- (void)initialize {
    [super initialize];
    
    [self setNavigationBarTitle:@"目录"];
}


#pragma mark - UI
- (void)createSubviews {
    [super createSubviews];
    
    self.mainTableView.rowHeight = 45.0;
    self.mainTableView.showsVerticalScrollIndicator = YES;
    self.mainTableView.contentInset = UIEdgeInsetsMake(0, 0, mSafeAreaInsertBottom, 0);
    [self.mainTableView m_registerCells:@[MAGBookCatalogTableViewCell1.class]];
    [self.view addSubview:self.mainTableView];
    
    mWeakobj(self)
    [self.mainTableView m_addNormalFooterRefreshWithRefreshingBlock:^{
        [MAGClickAgent event:@"用户上拉加载了一页小说目录"];
        if (weak_self.catalogModel.count == weak_self.catalogModel.list.count) {
            [weak_self.mainTableView m_endRefreshing];
            [weak_self.mainTableView m_endRefreshingWithNoMoreData];
            return;
        }

        [weak_self mp_requestNextPageCatalog];
    }];
    
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)setCatalogModel:(MAGBookCatalogModel *)catalogModel {
    [super setCatalogModel:catalogModel];
    
    [self.mainTableView reloadData];
}


#pragma mark - Private
- (void)mp_requestNextPageCatalog {
    NSString *chapterID = self.catalogModel.list.lastObject.chapterID ?: @"";
    
    mWeakobj(self)
    [self POST:mBookPaginationCatalogLink parameters:@{@"book_id" : self.bookID ?: @"", @"chapter_id" : chapterID} modelClass:MAGBookCatalogModel.class success:^(BOOL isSuccess, MAGBookCatalogModel * _Nullable t_model, BOOL isCache, MAGNetworkRequestModel * _Nonnull requestModel) {
        [weak_self.mainTableView m_endRefreshing];
        if (isSuccess) {
            if (t_model.list.count == 0) {
                [weak_self.mainTableView m_endRefreshingWithNoMoreData];
            }
            NSMutableArray<MAGBookCatalogListModel *> *catalogList = [weak_self.catalogModel.list mutableCopy];
            [catalogList addObjectsFromArray:t_model.list];
            t_model.list = catalogList;
            
            weak_self.catalogModel = t_model;
            
            [weak_self mp_updateLocalCatalog];
        } else {
            [mMainWindow m_showErrorHUDFromText:requestModel.msg ?: @"加载失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weak_self.mainTableView m_endRefreshing];
        [mMainWindow m_showErrorHUDFromError:error];
    }];
}

- (void)mp_updateLocalCatalog {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSDictionary *catalogDict = [NSDictionary m_dictionaryWithContentsOfFile:[MAGFileManager bookCatalogFilePathWithBookID:self.bookID]];
        MAGBookCatalogModel *catalogModel = [MAGBookCatalogModel modelWithDictionary:catalogDict];
        if (self.catalogModel.list.count > catalogModel.list.count) {
            [self.catalogModel m_writeToFile:[MAGFileManager bookCatalogFilePathWithBookID:self.bookID]];
        }
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.catalogModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MAGBookCatalogTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:MAGBookCatalogTableViewCell1.className forIndexPath:indexPath];
    MAGBookCatalogListModel *listModel = self.catalogModel.list[indexPath.row];
    cell.catalogModel = listModel;
    cell.choose = [listModel.chapterID isEqualToString:self.readInfo.chapterID];
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MAGBookCatalogListModel *listModel = self.catalogModel.list[indexPath.row];
    !self.switchChapterBlock ?: self.switchChapterBlock(listModel);
    [self m_popViewController];
}

@end

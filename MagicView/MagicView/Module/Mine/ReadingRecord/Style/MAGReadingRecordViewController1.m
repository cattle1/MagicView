//
//  MAGReadRecordViewController1.m
//  MagicView
//
//  Created by LL on 2021/10/21.
//

#import "MAGReadingRecordViewController1.h"

#import "MAGReadingRecordTableViewCell.h"

@implementation MAGReadingRecordViewController1

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setStatusBarLightStyle];
}

- (void)initialize {
    [super initialize];
    
    [self setNavigationBarTitle:@"阅读记录"];
}

- (void)createSubviews {
    [super createSubviews];
    
    [self.mainTableView registerClass:MAGReadingRecordTableViewCell.class forCellReuseIdentifier:MAGReadingRecordTableViewCell.className];
    self.mainTableView.contentInset = UIEdgeInsetsMake(0, 0, mSafeAreaInsertBottom, 0);
    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bookReadingArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MAGReadingRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MAGReadingRecordTableViewCell.className forIndexPath:indexPath];
    if (indexPath.row < self.bookReadingArray.count) {
        cell.bookModel = self.bookReadingArray[indexPath.row];
    } else {
        
    }
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.bookReadingArray.count) {
        [self readBookWihtBookModel:self.bookReadingArray[indexPath.row]];
    } else {
    }
}

@end

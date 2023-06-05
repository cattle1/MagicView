//
//  MAGRechargeViewController1.m
//  MagicView
//
//  Created by LL on 2021/10/20.
//

#import "MAGRechargeRecordViewController1.h"

#import "MAGRechargeRecordTableViewCell.h"

@implementation MAGRechargeRecordViewController1

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setStatusBarLightStyle];
}

- (void)initialize {
    [super initialize];
    
    [self setNavigationBarTitle:@"充值历史"];
}

- (void)createSubviews {
    [super createSubviews];
    
    [self.mainTableView registerClass:MAGRechargeRecordTableViewCell.class forCellReuseIdentifier:MAGRechargeRecordTableViewCell.className];
    self.mainTableView.contentInset = UIEdgeInsetsMake(0, 0, mSafeAreaInsertBottom, 0);
    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.right.left.bottom.equalTo(self.view);
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rechargeRecord.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MAGRechargeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MAGRechargeRecordTableViewCell.className forIndexPath:indexPath];
    cell.recordModel = self.rechargeRecord[indexPath.row];
    [cell setHiddenLine:(indexPath.row == self.rechargeRecord.count - 1)];
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MAGRechargeRecordModel *recordModel = self.rechargeRecord[indexPath.row];
    [MAGClickAgent event:@"用户点击了充值历史中的商品" attributes:@{@"apple_id" : recordModel.appleID ?: @"NULL", @"title" : recordModel.title ?: @"NULL", @"price" : recordModel.fatPrice ?: @"NULL"}];
}

@end

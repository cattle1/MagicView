//
//  MAGDarkModeViewController1.m
//  MagicView
//
//  Created by LL on 2021/10/22.
//

#import "MAGDarkModeViewController1.h"

#import "MAGDarkModeTableViewCell.h"

@interface MAGDarkModeViewController1 ()

@end

@implementation MAGDarkModeViewController1

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setStatusBarLightStyle];
}

- (void)initialize {
    [super initialize];
    
    [self setNavigationBarTitle:@"深色模式"];
    
    [self.dataSourceArray addObject:@(LLUserInterfaceStyleLight)];
    [self.dataSourceArray addObject:@(LLUserInterfaceStyleDark)];
}

- (void)createSubviews {
    [super createSubviews];
    
    self.mainTableView.backgroundColor = mBackgroundColor2;
    self.mainTableView.rowHeight = 45.0;
    self.mainTableView.backgroundColor = mBackgroundColor2;
    self.mainTableView.contentInset = UIEdgeInsetsMake(0, 0, mSafeAreaInsertBottom, 0);
    [self.mainTableView registerClass:MAGDarkModeTableViewCell.class forCellReuseIdentifier:MAGDarkModeTableViewCell.className];
    [self.view addSubview:self.mainTableView];
    
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MAGDarkModeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MAGDarkModeTableViewCell.className forIndexPath:indexPath];
    cell.style = [self.dataSourceArray[indexPath.row] integerValue];
    [cell setHiddenLine:(indexPath.row == self.dataSourceArray.count - 1)];
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MAGDarkModeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
    [self switchDarkMode:cell.style];
}

@end

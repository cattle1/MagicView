//
//  MAGRechargeViewController1.m
//  MagicView
//
//  Created by LL on 2021/10/19.
//

#import "MAGRechargeViewController1.h"

#import "MAGRechargeTableViewCell.h"

@interface MAGRechargeViewController1 ()

@property (nonatomic, weak) UILabel *memberDateLabel;

@property (nonatomic, weak) UILabel *remainLabel;

@property (nonatomic, weak) YYLabel *tipsLabel;

@end

@implementation MAGRechargeViewController1

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setStatusBarLightStyle];
}

- (void)initialize {
    [super initialize];
    
    [self setNavigationBarTitle:@"充值中心"];
    self.view.backgroundColor = mBackgroundColor1;
}

- (void)createSubviews {
    [super createSubviews];
    
    [self.mainTableView registerClass:MAGRechargeTableViewCell.class forCellReuseIdentifier:MAGRechargeTableViewCell.className];
    self.mainTableView.contentInset = UIEdgeInsetsMake(0, 0, mSafeAreaInsertBottom, 0);
    self.mainTableView.rowHeight = 45.0;
    self.mainTableView.hidden = YES;
    [self.view addSubview:self.mainTableView];
    
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    {
        UIView *headerView = [MAGUIFactory view];
        headerView.frame = CGRectMake(0, 0, kScreenWidth, 80);
        self.mainTableView.tableHeaderView = headerView;
        
        UIView *contentView = [MAGUIFactory viewWithBackgroundColor:mBackgroundColor2 cornerRadius:6.0];
        [headerView addSubview:contentView];
        
        UILabel *memberDateLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mFont18 textColor:mTextColor1];
        self.memberDateLabel = memberDateLabel;
        NSString *dateString = @"暂未开通会员";
        if (MAGUserInfoManager.userInfo.isVIP) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:MAGUserInfoManager.userInfo.memberEndTime];
            dateString = [date stringWithFormat:@"yyyy-MM-dd"];
        }
        memberDateLabel.text = [NSString stringWithFormat:@"%@: %@", @"会员状态", dateString];
        [contentView addSubview:memberDateLabel];
        
        UILabel *remainLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mFont18 textColor:mTextColor1];
        self.remainLabel = remainLabel;
        remainLabel.text = [NSString stringWithFormat:@"%@: %zd", @"我的余额", MAGUserInfoManager.userInfo.remain];
        [contentView addSubview:remainLabel];
        
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView).offset(mMoreHalfMargin);
            make.width.mas_equalTo(kScreenWidth - 2 * mMoreHalfMargin);
            make.top.bottom.equalTo(headerView).inset(mHalfMargin);
        }];
        
        [remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(contentView.mas_centerY).offset(-2.0);
            make.left.right.equalTo(contentView).inset(mHalfMargin);
            make.height.mas_equalTo([remainLabel.font m_textHeight]);
        }];
        
        [memberDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView.mas_centerY).offset(2.0);
            make.left.right.height.equalTo(remainLabel);
        }];
    }
    
    {
        UIView *footerView = [MAGUIFactory view];
        footerView.frame = CGRectMake(0, 0, kScreenWidth, 0.0);
        self.mainTableView.tableFooterView = footerView;
        
        YYLabel *tipsLabel = [MAGUIFactory yyLabel];
        self.tipsLabel = tipsLabel;
        tipsLabel.preferredMaxLayoutWidth = kScreenWidth - 2 * mMoreHalfMargin;
        tipsLabel.numberOfLines = 0;
        [footerView addSubview:tipsLabel];
        
        
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(footerView).offset(mMoreHalfMargin);
            make.width.mas_equalTo(kScreenWidth - 2 * mMoreHalfMargin);
            make.height.mas_equalTo(0.0);
        }];
        
        self.rechargeTips = self.rechargeTips;
    }
}


#pragma mark - Override
- (void)rechargeSuccess {
    [super rechargeSuccess];
    
    NSString *dateString = @"暂未开通会员";
    if (MAGUserInfoManager.userInfo.isVIP) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:MAGUserInfoManager.userInfo.memberEndTime];
        dateString = [date stringWithFormat:@"yyyy-MM-dd"];
    }
    self.memberDateLabel.text = [NSString stringWithFormat:@"%@: %@", @"会员状态", dateString];
    self.remainLabel.text = [NSString stringWithFormat:@"%@: %zd", @"我的余额", MAGUserInfoManager.userInfo.remain];
}

- (void)setHaveMember:(BOOL)haveMember {
    [super setHaveMember:haveMember];
    
    if (!haveMember) {
        self.memberDateLabel.hidden = YES;
        [self.remainLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0.0);
            make.left.right.height.equalTo(self.memberDateLabel);
        }];
    }
}

- (void)setHaveRecharge:(BOOL)haveRecharge {
    [super setHaveRecharge:haveRecharge];
    
    if (!haveRecharge) {
        self.remainLabel.hidden = YES;
        [self.memberDateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0.0);
            make.left.mas_equalTo(mHalfMargin);
            make.right.mas_equalTo(-mHalfMargin);
            make.height.mas_equalTo([self.memberDateLabel.font m_textHeight]);
        }];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MAGRechargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MAGRechargeTableViewCell.className forIndexPath:indexPath];
    cell.itemModel = self.list[indexPath.row];
    [cell setHiddenLine:(indexPath.row == self.list.count - 1)];
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MAGTableSectionView *sectionView = tableView.m_reusableSectionView;
    sectionView.contentView.backgroundColor = mBackgroundColor2;
    
    UILabel *titleLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mFont16 textColor:mTextColor1];
    titleLabel.text = @"商品列表";
    [sectionView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(sectionView).inset(mMargin);
        make.top.height.equalTo(sectionView);
    }];
    
    return sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return tableView.m_reusableSectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MAGRechargeItemModel *itemModel = self.list[indexPath.row];
    [self requestProduct:itemModel];
}


#pragma mark - Setter
- (void)setList:(NSArray<MAGRechargeItemModel *> *)list {
    [super setList:list];
    
    self.mainTableView.hidden = NO;
    [self.mainTableView reloadData];
}

- (void)setRechargeTips:(NSArray<NSString *> *)tips {
    [super setRechargeTips:tips];
    
    if (tips.count < 2) return;
    
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@\n", tips.firstObject];
    for (NSInteger i = 1; i < tips.count; i++) {
        NSString *t_str = [NSString stringWithFormat:@"%zd. %@\n", i, tips[i]];
        [string appendString:t_str];
    }
    
    NSString *privacyProtocol = @"隐私政策";
    NSString *memberString = @"会员协议";
    
    [string appendString:[NSString stringWithFormat:@"%zd. %@ · %@", tips.count, privacyProtocol, memberString]];
    
    NSMutableAttributedString *tipsAttributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName : mFont14, NSForegroundColorAttributeName : mTextColor2}];
    [tipsAttributedString setAttributes:@{NSFontAttributeName : mBoldFont15, NSForegroundColorAttributeName : mTextColor1} range:NSMakeRange(0, tips.firstObject.length)];
    tipsAttributedString.lineSpacing = mQuarterMargin;
    
    [tipsAttributedString setAttribute:YYTextUnderlineAttributeName value:[YYTextDecoration decorationWithStyle:YYTextLineStyleSingle width:@(1.0) color:mTextColor2] range:[tipsAttributedString.string rangeOfString:privacyProtocol]];
    [tipsAttributedString setAttribute:YYTextUnderlineAttributeName value:[YYTextDecoration decorationWithStyle:YYTextLineStyleSingle width:@(1.0) color:mTextColor2] range:[tipsAttributedString.string rangeOfString:memberString]];
    
    [tipsAttributedString setTextHighlightRange:[tipsAttributedString.string rangeOfString:privacyProtocol] color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [UIApplication.sharedApplication openURL:mPrivacyProtocolLink.m_URL options:@{} completionHandler:nil];
        [MAGClickAgent event:@"用户点击了关于页面的隐私协议" attributes:@{@"url" : mPrivacyProtocolLink}];
    }];
    
    [tipsAttributedString setTextHighlightRange:[tipsAttributedString.string rangeOfString:memberString] color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [UIApplication.sharedApplication openURL:mVipProtocolLink.m_URL options:@{} completionHandler:nil];
        [MAGClickAgent event:@"用户点击了关于页面的会员协议" attributes:@{@"url" : mVipProtocolLink}];
    }];
    
    self.tipsLabel.attributedText = tipsAttributedString;
    
    CGFloat textHeight = self.tipsLabel.m_textHeight;
    [self.tipsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textHeight);
    }];
    
    [self.mainTableView updateWithBlock:^(UITableView * _Nonnull tableView) {
        self.mainTableView.tableFooterView.frame = CGRectMake(0, 0, kScreenWidth, textHeight + mMoreHalfMargin);
    }];
}

@end

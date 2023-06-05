//
//  MAGRechargeViewController.m
//  MagicView
//
//  Created by LL on 2021/10/20.
//

#import "MAGRechargeRecordViewController.h"

#import "MAGRechargeRecordViewController1.h"

@implementation MAGRechargeRecordViewController

@synthesize rechargeRecord = _rechargeRecord;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [MAGClickAgent appendDidAppearViewControllerName:@"充值历史页面"];
    [MAGClickAgent event:@"用户进入充值历史页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MAGClickAgent event:@"用户离开充值历史页面"];
}

+ (instancetype)rechargeRecordViewController {
    return [[MAGRechargeRecordViewController1 alloc] init];
}

- (void)createSubviews {
    [super createSubviews];
    
    UILabel *tipsLabel = [MAGUIFactory labelWithBackgroundColor:nil font:mBoldFont18 textColor:mPlaceholderColor];
    self.tipsLabel = tipsLabel;
    tipsLabel.text = @"暂无数据";
    tipsLabel.hidden = (self.rechargeRecord.count > 0);
    [self.view addSubview:tipsLabel];
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(tipsLabel.m_textSize);
    }];
}


#pragma mark - Getter
- (NSArray<MAGRechargeRecordModel *> *)rechargeRecord {
    if (_rechargeRecord == nil) {
        NSArray<NSDictionary *> *recordArray = [NSArray m_arrayWithContentsOfFile:MAGFileManager.rechargeRecordFilePath];
        _rechargeRecord = [NSArray modelArrayWithClass:MAGRechargeRecordModel.class json:recordArray];
        if (_rechargeRecord == nil) {
            _rechargeRecord = @[];
        }
    }
    
    return _rechargeRecord;
}

@end

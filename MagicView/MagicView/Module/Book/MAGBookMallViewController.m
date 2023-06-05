//
//  MAGBookMallViewController.m
//  MagicView
//
//  Created by LL on 2021/9/22.
//

#import "MAGBookMallViewController.h"

@implementation MAGBookMallViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setStatusBarAutoStyle];
}

- (void)initialize {
    [super initialize];

    [self setNavigationBarTitle:@"书城"];
    [mNotificationCenter postNotificationName:MAGBookMallViewDidLoadNotification object:nil];
}

- (void)createSubviews {
    [super createSubviews];
    
    UIImageView *backgroundImageView = [MAGUIFactory imageViewWithBackgroundColor:nil image:[UIImage imageNamed:@"public_background"] cornerRadius:0.0];
    [self.view addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}


- (void)netRequest {
    [self POSTQuick:@"/v1/home/index" parameters:nil modelClass:nil success:^(BOOL isSuccess, id  _Nullable t_model, BOOL isCache, MAGNetworkRequestModel * _Nonnull requestModel) {
        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"");
    }];
}

@end

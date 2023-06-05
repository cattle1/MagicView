//
//  MAGRackViewController.m
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import "MAGRackViewController.h"

@implementation MAGRackViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.bookCollect = [[MAGBookRecordManager collectionRecord] mutableCopy];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [MAGClickAgent event:@"用户进入书架页面"];
    [MAGClickAgent appendDidAppearViewControllerName:@"书架页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MAGClickAgent event:@"用户离开书架页面"];
}

- (void)initialize {
    [super initialize];
    [self setNavigationBarTitle:@"书架"];
}

@end

//
//  MagicViewController.m
//  MagicView
//
//  Created by LL on 2021/7/6.
//

#import "MAGViewController.h"

#import "MAGNetworkReachabilityManager.h"

@interface MAGViewController ()

@property (nonatomic, strong) NSMutableArray *netRequestArray;

@end

@implementation MAGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self defaultInitialize];
    [self initialize];
    [self createSubviews];
    [self netRequest];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // 处理保存的网络请求Block，解决相互引用
    if (self.netRequestArray.count > 0) {
        BOOL isResult = NO;
        for (id obj in self.navigationController.viewControllers) {
            isResult = (obj == self);
            if (isResult) break;
        }
        
        if (!isResult) {
            [self.netRequestArray removeAllObjects];
        }
    }
}

- (void)defaultInitialize {
    self.view.backgroundColor = mBackgroundColor1;
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_11_0
    self.automaticallyAdjustsScrollViewInsets = NO;
#endif
    self.canSlidingBack = YES;
    
    if (mNavBarBackgroundColor.m_isGradientColor) {
        [self setStatusBarLightStyle];
    } else {
        if (mNavBarBackgroundColor.m_isDarkColor) {
            [self setStatusBarLightStyle];
        } else {
            [self setStatusBarDarkStyle];
        }
    }
    
    [mNotificationCenter addObserver:self selector:@selector(reachabilityStatusDidChangeNotification) name:MAGNetworkReachabilityStatusDidChangeNotification object:nil];
    [mNotificationCenter addObserver:self selector:@selector(appDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    [mNotificationCenter addObserver:self selector:@selector(appWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
}


- (void)initialize {}

- (void)createSubviews {}

- (void)netRequest {}

- (void)POST:(NSString *)url parameters:(NSDictionary * _Nullable)parameters modelClass:(Class _Nullable)modelClass success:(m_requestSuccessBlock)success failure:(m_requestFailedBlock)failure {
    [self mp_onceNetworkRequest:^{
        [MAGNetworkRequestManager POST:url parameters:parameters modelClass:modelClass success:success failure:failure];
    }];
}

- (void)POSTQuick:(NSString *)url parameters:(NSDictionary * _Nullable)parameters modelClass:(Class _Nullable)modelClass success:(m_requestSuccessBlock)success failure:(m_requestFailedBlock)failure {
    [self mp_onceNetworkRequest:^{
        [MAGNetworkRequestManager POST:url parameters:parameters modelClass:modelClass needCache:YES autoRequest:NO completionQueue:nil success:success failure:failure];
    }];
}


#pragma mark - Private
/// 确保会发送一次有效的网络请求
- (void)mp_onceNetworkRequest:(void (^)(void))block {
    if (MAGNetworkReachabilityManager.isReachable) {
        !block ?: block();
        return;
    }
    
    [self.netRequestArray addObject:block];
}


#pragma mark - Notification
- (void)reachabilityStatusDidChangeNotification {
    if (MAGNetworkReachabilityManager.isReachable) {
        for (id obj in self.netRequestArray) {
            void (^t_block)(void) = obj;
            t_block();
        }
        [self.netRequestArray removeAllObjects];
    }
}

- (void)appDidBecomeActiveNotification {}

- (void)appWillResignActiveNotification {}


#pragma mark - Getter
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (UITableView *)mainTableView {
    __autoreleasing UITableView *mainTableView = nil;
    if (!_mainTableView) {
        mainTableView = [MAGUIFactory tableViewWithBackgroundColor:nil delegate:self style:UITableViewStylePlain cellClass:nil];
        _mainTableView = mainTableView;
    }
    return _mainTableView;
}

- (UITableView *)mainTableViewGroup {
    __autoreleasing UITableView *mainTableViewGroup = nil;
    if (!_mainTableViewGroup) {
        mainTableViewGroup = [MAGUIFactory tableViewWithBackgroundColor:nil delegate:self style:UITableViewStyleGrouped cellClass:nil];
        _mainTableViewGroup = mainTableViewGroup;
    }
    return _mainTableViewGroup;
}

- (UICollectionViewFlowLayout *)mainCollectionViewFlowLayout {
    __autoreleasing UICollectionViewFlowLayout *mainCollectionViewFlowLayout = nil;
    if (!_mainCollectionViewFlowLayout) {
        mainCollectionViewFlowLayout = [MAGUIFactory collectionViewFlowLayout];
        _mainCollectionViewFlowLayout = mainCollectionViewFlowLayout;
    }
    return _mainCollectionViewFlowLayout;
}

- (UICollectionView *)mainCollectionView {
    __autoreleasing UICollectionView *mainCollectionView = nil;
    if (!_mainCollectionView) {
        mainCollectionView = [MAGUIFactory collectionViewWithLayout:self.mainCollectionViewFlowLayout backgroundColor:nil delegate:self cellClass:nil];
        _mainCollectionView = mainCollectionView;
    }
    return _mainCollectionView;
}

- (NSMutableArray *)netRequestArray {
    if (!_netRequestArray) {
        _netRequestArray = [NSMutableArray array];
    }
    return _netRequestArray;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [UICollectionViewCell new];
}

@end

//
//  MAGView.m
//  MagicView
//
//  Created by LL on 2021/7/16.
//

#import "MAGView.h"

#import "MAGNetworkReachabilityManager.h"

@interface MAGView ()

@property (nonatomic, strong) NSMutableArray *netRequestArray;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation MAGView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self defaultInitialize];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (self.superview == nil) {
        [self.netRequestArray removeAllObjects];
    }
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    if (!self.isFirst) {
        self.isFirst = YES;
        [self initialize];
        [self createSubviews];
        [self netRequest];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.backgroundColor.m_isGradientColor) {
        self.backgroundColor = self.backgroundColor;
    }
    
    !self.m_frameBlock ?: self.m_frameBlock(self);
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (backgroundColor.m_isGradientColor) {
        [super setBackgroundColor:[UIColor m_createGradientColorWithSize:self.size delayGradientColor:backgroundColor]];
    } else {
        [super setBackgroundColor:backgroundColor];
    }
}

- (void)defaultInitialize {    
    self.backgroundColor = mBackgroundColor1;
    [mNotificationCenter addObserver:self selector:@selector(reachabilityStatusDidChangeNotification) name:MAGNetworkReachabilityStatusDidChangeNotification object:nil];
}

- (void)initialize {}

- (void)createSubviews {}

- (void)netRequest {}

- (void)POST:(NSString *)url
  parameters:(NSDictionary * _Nullable)parameters
  modelClass:(Class _Nullable)modelClass
     success:(m_requestSuccessBlock)success
     failure:(m_requestFailedBlock)failure {
    [self mp_onceNetworkRequest:^{
        [MAGNetworkRequestManager POST:url parameters:parameters modelClass:modelClass success:success failure:failure];
    }];
}

- (void)POSTQuick:(NSString *)url
       parameters:(NSDictionary * _Nullable)parameters
       modelClass:(Class _Nullable)modelClass
          success:(m_requestSuccessBlock)success
          failure:(m_requestFailedBlock)failure {
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

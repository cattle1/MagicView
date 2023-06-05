//
//  MAGView.h
//  MagicView
//
//  Created by LL on 2021/7/16.
//

#import <UIKit/UIKit.h>

#import "MAGImport.h"
#import "MAGNetworkRequestManager.h"

#import "MAGTableSectionView.h"
#import "MAGView.h"
#import "MAGLabel.h"
#import "MAGYYLabel.h"
#import "MAGImageView.h"
#import "MAGAnimatedImageView.h"
#import "MAGButton.h"
#import "MAGTextField.h"
#import "MAGScrollView.h"
#import "MAGTextView.h"
#import "MAGYYTextView.h"
#import "MAGTableView.h"
#import "MAGCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGView : UIView<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, weak) UITableView *mainTableView;

@property (nonatomic, weak) UITableView *mainTableViewGroup;

@property (nonatomic, weak) UICollectionViewFlowLayout *mainCollectionViewFlowLayout;

@property (nonatomic, weak) UICollectionView *mainCollectionView;

/// 智能的POST请求
/// @discussion 正常的 POST 请求会在断网情况下请求失败，而且恢复网络后不会自动重新请求
///             该方法会在断网情况下保存请求，并且恢复网络后自动重新请求
/// @note 当 self 对象从父视图移除时会自动删除保存的请求，success 和 failure 内可以正常使用 self 不会造成循环
- (void)POST:(NSString *)url
  parameters:(NSDictionary * _Nullable)parameters
  modelClass:(Class _Nullable)modelClass
     success:(m_requestSuccessBlock)success
     failure:(m_requestFailedBlock)failure;

/// 智能的POST Cache请求
/// @discussion 详情请参考  - POST: parameters: modelClass: success: failure: 
- (void)POSTQuick:(NSString *)url
       parameters:(NSDictionary * _Nullable)parameters
       modelClass:(Class _Nullable)modelClass
          success:(m_requestSuccessBlock)success
          failure:(m_requestFailedBlock)failure;



/// 当 View 显示后调用而不是初始化后调用
- (void)initialize;

/// 当 View 显示后调用而不是初始化后调用
- (void)createSubviews;

/// 当 View 显示后调用而不是初始化后调用
- (void)netRequest;

@end

NS_ASSUME_NONNULL_END

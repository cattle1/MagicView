//
//  MAGCollectionViewCell.h
//  MagicView
//
//  Created by LL on 2021/10/21.
//

#import <UIKit/UIKit.h>

#import "MAGImport.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak, nullable) UICollectionView *mainCollectionView;

@property (nonatomic, strong, nullable) NSIndexPath *cellIndexPath;

- (void)initialize;

- (void)createSubviews;

@end

NS_ASSUME_NONNULL_END

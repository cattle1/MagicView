//
//  MAGBookCatalogTableViewCell.h
//  MagicView
//
//  Created by LL on 2021/8/31.
//

#import "MAGTableViewCell.h"

@class MAGBookCatalogListModel;

NS_ASSUME_NONNULL_BEGIN

@interface MAGBookCatalogTableViewCell1 : MAGTableViewCell

@property (nonatomic, strong) MAGBookCatalogListModel *catalogModel;

@property (nonatomic, assign, getter=isChoose) BOOL choose;

@end

NS_ASSUME_NONNULL_END

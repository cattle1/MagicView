//
//  MAGReadingRecordTableViewCell.h
//  MagicView
//
//  Created by LL on 2021/10/21.
//

#import "MAGTableViewCell.h"

@class MAGBookModel;

NS_ASSUME_NONNULL_BEGIN

@interface MAGReadingRecordTableViewCell : MAGTableViewCell

@property (nonatomic, strong) MAGBookModel *bookModel;

@end

NS_ASSUME_NONNULL_END

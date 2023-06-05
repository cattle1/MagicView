//
//  MAGRackViewController.h
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import "MAGViewController.h"

#import "MAGBookRecordManager.h"
#import "MAGBookReaderViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGRackViewController : MAGViewController

@property (nonatomic, strong) NSMutableArray<MAGBookModel *> *bookCollect;

@end

NS_ASSUME_NONNULL_END

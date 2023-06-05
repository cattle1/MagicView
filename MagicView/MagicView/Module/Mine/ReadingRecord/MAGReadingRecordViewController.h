//
//  MAGReadRecordViewController.h
//  MagicView
//
//  Created by LL on 2021/10/21.
//

#import "MAGViewController.h"

#import "MAGBookRecordManager.h"

#import "MAGBookReaderViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGReadingRecordViewController : MAGViewController

@property (nonatomic, copy, readonly) NSArray<MAGBookModel *> *bookReadingArray;

+ (instancetype)readingRecordViewController;

- (void)readBookWihtBookModel:(MAGBookModel *)bookModel;

@end

NS_ASSUME_NONNULL_END

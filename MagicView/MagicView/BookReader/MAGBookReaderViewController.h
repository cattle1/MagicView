//
//  MAGBookReaderViewController.h
//  MagicView
//
//  Created by LL on 2021/7/9.
//

#import "MAGViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGBookReaderViewController : MAGViewController

- (instancetype)initWithBookID:(NSString *)bookID;

- (instancetype)initWithBookID:(NSString *)bookID chapterID:(NSString *)chapterID;

- (instancetype)initWithBookID:(NSString *)bookID chapterIndex:(NSUInteger)chapterIndex;

@end

NS_ASSUME_NONNULL_END

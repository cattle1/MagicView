//
//  MAGBookRetryView.h
//  MagicView
//
//  Created by LL on 2021/9/17.
//

#import "MAGView.h"

#import "MAGBookReaderManager.h"

@class MAGBookPageContentModel;

NS_ASSUME_NONNULL_BEGIN

@interface MAGBookRetryView : MAGView

@property (nonatomic, strong, nullable) MAGBookPageContentModel *pageContent;

@end

NS_ASSUME_NONNULL_END

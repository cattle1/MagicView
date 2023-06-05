//
//  MAGBookBuyView.h
//  MagicView
//
//  Created by LL on 2021/9/15.
//

#import "MAGView.h"

#import "MAGBookReaderManager.h"
#import "MAGBookPageContentModel.h"

@class MAGBookPageContentModel;

NS_ASSUME_NONNULL_BEGIN

@interface MAGBookBuyView : MAGView

@property (nonatomic, strong, nullable) MAGBookPageContentModel *pageContent;

@property (nonatomic, weak) UIImageView *backgroundImageView;

+ (instancetype)buyViewWithPageContent:(MAGBookPageContentModel * _Nullable)pageContent;

/// 通知观察者小说阅读器的背景已发生改变
- (void)backgroundImageDidChangeNotification;

- (void)buyChapterContent;

@end

NS_ASSUME_NONNULL_END

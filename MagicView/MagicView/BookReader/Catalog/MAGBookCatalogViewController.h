//
//  MAGBookCatalogViewController.h
//  MagicView
//
//  Created by LL on 2021/10/23.
//

#import "MAGViewController.h"

#import "MAGBookRecordManager.h"
#import "MAGBookCatalogModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGBookCatalogViewController : MAGViewController

@property (nonatomic, copy, readonly) NSString *bookID;

@property (nonatomic, strong, readonly) MAGBookReadModel *readInfo;

@property (nonatomic, strong) MAGBookCatalogModel *catalogModel;

@property (nonatomic, copy) void(^switchChapterBlock)(MAGBookCatalogListModel *catalogModel);

+ (instancetype)catalogViewControllerWithBookID:(NSString *)bookID;

@end

NS_ASSUME_NONNULL_END

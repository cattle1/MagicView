//
//  MAGBookMallModel.h
//  MagicView
//
//  Created by LL on 2023/4/12.
//

#import <Foundation/Foundation.h>

@class MAGBookMallBannerModel;

NS_ASSUME_NONNULL_BEGIN

@interface MAGBookMallModel : NSObject

@property (nonatomic, copy) NSArray<MAGBookMallBannerModel *> *banner;

@end


@interface MAGBookMallBannerModel : NSObject

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *skip_content;

@end


@interface MAGBookMallListModel : NSObject

@property (nonatomic, assign) BOOL can_more;

@property (nonatomic, copy) NSString *recommend_id;

@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END

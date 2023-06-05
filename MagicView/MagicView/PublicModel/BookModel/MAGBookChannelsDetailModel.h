//
//  MAGBookChannelsDetailModel.h
//  MagicView
//
//  Created by TSL on 2022/6/9.
//

#import <Foundation/Foundation.h>
#import "MAGBannerModel.h"
#import "MAGBookChannelsDetailLabelModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGBookChannelsDetailModel : NSObject

@property (nonatomic, copy) NSArray<MAGBannerModel *> *banner;

@property (nonatomic, copy) NSArray<MAGBookChannelsDetailLabelModel *> *label;

@end

NS_ASSUME_NONNULL_END

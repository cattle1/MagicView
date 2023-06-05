//
//  MAGBookChannelsDetailModel.m
//  MagicView
//
//  Created by TSL on 2022/6/9.
//

#import "MAGBookChannelsDetailModel.h"

@implementation MAGBookChannelsDetailModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"banner" : MAGBannerModel.class,
        @"label" : MAGBookChannelsDetailLabelModel.class
    };
}

@end

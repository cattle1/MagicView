//
//  MAGBookMallModel.m
//  MagicView
//
//  Created by LL on 2023/4/12.
//

#import "MAGBookMallModel.h"

@implementation MAGBookMallModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"banner" : MAGBookMallBannerModel.class
    };
}

@end


@implementation MAGBookMallBannerModel

@end



@implementation MAGBookMallListModel

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
        @"title" : @[@"label", @"title"]
    };
}

@end

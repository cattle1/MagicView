//
//  MAGBookChannelsDetailLabelModel.m
//  MagicView
//
//  Created by TSL on 2022/6/9.
//

#import "MAGBookChannelsDetailLabelModel.h"

@implementation MAGBookChannelsDetailLabelModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"list" : MAGBookModel.class
    };
}

@end

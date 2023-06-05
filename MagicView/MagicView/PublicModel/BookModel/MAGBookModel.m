//
//  MAGBookModel.m
//  MagicView
//
//  Created by LL on 2021/7/9.
//

#import "MAGBookModel.h"

@implementation MAGBookModel

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
        @"desc" : @[@"description", @"desc"]
    };
}

@end

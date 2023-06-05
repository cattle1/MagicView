//
//  YTSliderSetting.m
//  YTSliderView
//
//  Created by yitezh on 2019/10/19.
//  Copyright © 2019 yitezh. All rights reserved.
//

#import "MAGSliderSetting.h"

@implementation MAGSliderSetting

+ (instancetype)defaultSetting {
    MAGSliderSetting *setting = [[MAGSliderSetting alloc]init];
    setting.borderWidth = 4;
    setting.progressInset = 2;
    setting.shouldShowProgress = YES;
    setting.layoutDirection = MAGSliderLayoutDirectionHorizontal;
    setting.thumbColor = [UIColor whiteColor];
    setting.backgroundColor = [UIColor whiteColor];
    setting.progressColor = [UIColor colorWithRed:43/255.0 green:157/255.0 blue:247/255.0 alpha:1.0];
    setting.thumbBorderColor = [UIColor colorWithRed:43/255.0 green:157/255.0 blue:247/255.0 alpha:1.0];
    return setting;
}

+ (instancetype)verticalSetting {
    MAGSliderSetting *setting = [[MAGSliderSetting alloc]init];
    setting.borderWidth = 2;
    setting.progressInset = 1;
    setting.layoutDirection = MAGSliderLayoutDirectionVertical;
    setting.backgroundColor = [UIColor whiteColor];
    setting.progressColor = [UIColor colorWithRed:43/255.0 green:157/255.0 blue:247/255.0 alpha:1.0];
    setting.thumbBorderColor = [UIColor colorWithRed:43/255.0 green:157/255.0 blue:247/255.0 alpha:1.0];
    setting.thumbColor = [UIColor whiteColor];
    setting.shouldShowProgress = YES;
    return setting;
}

@end

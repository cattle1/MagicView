//
//  YTVolumeSliderView.h
//  ytSliderView
//
//  Created by yitezh on 2019/10/18.
//  Copyright © 2019 yitezh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAGSliderSetting.h"
@class MAGSliderView;
NS_ASSUME_NONNULL_BEGIN



@protocol MAGSliderViewDelegate <NSObject>

@optional

- (void)sliderView:(MAGSliderView *)view didChangePercent:(CGFloat)percent;

- (void)sliderViewDidBeginDrag:(MAGSliderView *)view;

- (void)sliderViewDidEndDrag:(MAGSliderView *)view;
@end



@interface MAGSliderView : UIView

- (instancetype)initWithFrame:(CGRect)frame setting:(MAGSliderSetting *)setting;

//滑杆初始位置（零点位置）
@property (assign, nonatomic) CGFloat anchorPercent;
//当前百分比
@property (assign, nonatomic) CGFloat currentPercent;
//总值（主要用于显示）
@property (assign, nonatomic) NSInteger sumValue;
//setting用于静态属性
@property (strong, nonatomic) MAGSliderSetting *setting;

@property (weak, nonatomic) id<MAGSliderViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END

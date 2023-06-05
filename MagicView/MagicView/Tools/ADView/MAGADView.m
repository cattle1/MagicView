//
//  MAGADView.m
//  MagicView
//
//  Created by LL on 2021/10/25.
//

#import "MAGADView.h"

#import "MAGBUAView.h"

@implementation MAGADView

+ (nullable instancetype)adView {
    if (mBUASwitch) {
        return [[MAGBUAView alloc] init];
    } else {
        return nil;
    }
}

@end

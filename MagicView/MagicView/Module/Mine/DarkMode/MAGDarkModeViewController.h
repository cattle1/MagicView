//
//  MAGDarkModeViewController.h
//  MagicView
//
//  Created by LL on 2021/10/22.
//

#import "MAGViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGDarkModeViewController : MAGViewController

+ (instancetype)darkModeViewController;

- (void)switchDarkMode:(LLUserInterfaceStyle)style;

@end

NS_ASSUME_NONNULL_END

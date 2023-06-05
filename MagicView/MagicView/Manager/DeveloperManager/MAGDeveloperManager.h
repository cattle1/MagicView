//
//  MAGDeveloperManager.h
//  MagicView
//
//  Created by LL on 2021/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAGDeveloperManager : NSObject

/// 根据命令执行相关开发者功能
+ (void)developerFunctionWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END

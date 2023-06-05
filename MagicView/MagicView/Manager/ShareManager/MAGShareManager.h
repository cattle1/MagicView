//
//  MAGShareManager.h
//  MagicView
//
//  Created by LL on 2021/9/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAGShareManager : NSObject

+ (void)shareBookWithName:(NSString *)name cover:(UIImage *)cover;

+ (void)shareWithTitle:(NSString * _Nullable)title image:(UIImage * _Nullable)image URL:(NSURL * _Nullable)URL;

+ (void)shareWithTitle:(NSString * _Nullable)title
            image:(UIImage * _Nullable)image
              URL:(NSURL * _Nullable)URL
            handler:(_Nullable UIActivityViewControllerCompletionWithItemsHandler)handler;
@end

NS_ASSUME_NONNULL_END

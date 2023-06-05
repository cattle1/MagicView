//
//  MAGShareManager.m
//  MagicView
//
//  Created by LL on 2021/9/7.
//

#import "MAGShareManager.h"

#import "MAGImport.h"

@implementation MAGShareManager

+ (void)shareBookWithName:(NSString *)name cover:(UIImage *)cover {
    if (mObjectIsEmpty(name)) name = mAppName;
    
    if (cover == nil) cover = [UIImage imageNamed:mAppLogoName];
    
    [self shareWithTitle:name image:cover URL:mAppStoreLink.m_URL];
}

+ (void)shareWithTitle:(NSString * _Nullable)title image:(UIImage * _Nullable)image URL:(NSURL * _Nullable)URL {
    [self shareWithTitle:title image:image URL:URL handler:nil];
}

+ (void)shareWithTitle:(NSString * _Nullable)title
            image:(UIImage * _Nullable)image
              URL:(NSURL * _Nullable)URL
               handler:(_Nullable UIActivityViewControllerCompletionWithItemsHandler)handler {
    NSMutableArray *shareArray = [NSMutableArray array];
    
    if (title) {
        [shareArray addObject:title];
    }
    
    if (image) {
        [shareArray addObject:image];
    }
    
    if (URL) {
        [shareArray addObject:URL];
    }
    
    UIActivityViewController *shareVC = [[UIActivityViewController alloc] initWithActivityItems:shareArray applicationActivities:nil];
    void (^handlerBlock)(UIActivityType __nullable, BOOL, NSArray * __nullable, NSError * __nullable) = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        !handler ?: handler(activityType, completed, returnedItems, activityError);
        [MAGClickAgent event:[NSString stringWithFormat:@"分享%@", activityError ? @"失败" : @"成功"] attributes:@{@"share_identifier" : activityType ?: @"NULL"}];
    };
    shareVC.completionWithItemsHandler = handlerBlock;
    [mCurrentViewController presentViewController:shareVC animated:YES completion:nil];
    
    [MAGClickAgent event:@"用户点击了分享" attributes:@{@"title" : title ?: @"NULL"}];
}

@end

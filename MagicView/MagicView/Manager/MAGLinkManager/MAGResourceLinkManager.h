//
//  MAGLinkManager.h
//  MagicView
//
//  Created by LL on 2021/8/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 资源管理类
/// APP内所有资源统一采用网络 + URL 形式管理与获取
@interface MAGResourceLinkManager : NSObject

@property (nonatomic, class, readonly) NSURL *wechatLogoImageLink;

@property (nonatomic, class, readonly) NSURL *qqLogoImageLink;

/// 下载需要的所有网络资源
+ (void)downloadNetworkResources;

@end

NS_ASSUME_NONNULL_END

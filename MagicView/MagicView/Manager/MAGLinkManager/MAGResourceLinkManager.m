//
//  MAGLinkManager.m
//  MagicView
//
//  Created by LL on 2021/8/30.
//

#import "MAGResourceLinkManager.h"

#import "MAGImport.h"
#import "MAGNetworkDownloadManager.h"

@interface MAGResourceLinkManager ()

@property (nonatomic, class, readonly) NSString *prefixURL;

@end

@implementation MAGResourceLinkManager

+ (NSURL *)wechatLogoImageLink {
    static NSURL *_wechatLogoImageLink;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _wechatLogoImageLink = [self.prefixURL stringByAppendingString:@"wechat.png"].m_URL;
    });
    return _wechatLogoImageLink;
}

+ (NSURL *)qqLogoImageLink {
    static NSURL *_qqLogoImageLink;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _qqLogoImageLink = [self.prefixURL stringByAppendingString:@"qq.png"].m_URL;
    });
    return _qqLogoImageLink;
}

+ (void)downloadNetworkResources {
    [self downloadNickname];
    
    if (mWechatLoginSwitch) {
        [MAGNetworkDownloadManager downloadImageWithURL:[self wechatLogoImageLink]];
    }
    if (mQQLoginSwitch) {
        [MAGNetworkDownloadManager downloadImageWithURL:[self qqLogoImageLink]];
    }
}

/// 下载昵称
+ (void)downloadNickname {
    if (![mFileManager fileExistsAtPath:MAGFileManager.chineseNicknameFilePath]) {
        NSURL *chineseNameURL = [self.prefixURL stringByAppendingString:@"chineseName.txt"].m_URL;
        [MAGNetworkDownloadManager downloadTaskWithURL:chineseNameURL savePath:MAGFileManager.chineseNicknameFilePath progress:nil completionHandler:nil];
    }
    
    if (![mFileManager fileExistsAtPath:MAGFileManager.englishNicknameFilePath]) {
        NSURL *englishNameURL = [self.prefixURL stringByAppendingString:@"englishName.txt"].m_URL;
        [MAGNetworkDownloadManager downloadTaskWithURL:englishNameURL savePath:MAGFileManager.englishNicknameFilePath progress:nil completionHandler:nil];
    }
}

+ (NSString *)prefixURL {
    static NSString *prefixURL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        prefixURL = [NSString stringWithFormat:@"%@%@", APIURL, @"/resource/"];
    });
    return prefixURL;
}

@end

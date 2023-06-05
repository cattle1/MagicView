//
//  WXYZ_SystemInfoManager.m
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import "WXYZ_SystemInfoManager.h"

static NSString *_magicStatus = nil;

@implementation WXYZ_SystemInfoManager

+ (void)initialize {
    _magicStatus = [NSUserDefaults.standardUserDefaults objectForKey:@"magicStatus"];
}

+ (void)setMagicStatus:(NSString *)magicStatus {
    _magicStatus = magicStatus;
    [NSUserDefaults.standardUserDefaults setObject:magicStatus forKey:@"magicStatus"];
}

+ (NSString *)magicStatus {
    return _magicStatus;
}

@end

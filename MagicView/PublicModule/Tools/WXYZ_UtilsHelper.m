//
//  WXYZ_UtilsHelper.m
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import "WXYZ_UtilsHelper.h"

#import "WXYZ_SystemInfoManager.h"

@implementation WXYZ_UtilsHelper

+ (BOOL)isInSafetyPeriod {
#if WX_Enable_Magic
    if ([WXYZ_SystemInfoManager.magicStatus isEqualToString:@"0"]) {
        return NO;
    } else if ([WXYZ_SystemInfoManager.magicStatus isEqualToString:@"1"]) {
        return YES;
    }
    
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 提交审核日期
    NSDate *sd = [date dateFromString:Submission_Date];
    
    // 预计审核成功日期
    NSDate *ead = [[NSDate date] initWithTimeInterval:24 * 3600 * DELAY_DAYS sinceDate:sd];
    
    // 预计日期 - 当前日期
    NSTimeInterval si = [ead timeIntervalSince1970] * 1;
    NSTimeInterval ei = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    NSTimeInterval value = si - ei;
    
    // 天
    int day = (int)value / (24 * 3600);
    
    return (day > 0);
#else
    return NO;
#endif
}

@end

//
//  MAGDeveloperManager.m
//  MagicView
//
//  Created by LL on 2021/10/21.
//

#import "MAGDeveloperManager.h"

#import "MAGImport.h"

@implementation MAGDeveloperManager

+ (void)developerFunctionWithText:(NSString *)text {
    if ([text isEqualToString:@"切换到正式版"]) {
        [mNotificationCenter postNotificationName:MAGSwitchFormalStateNotification object:nil];
        return;
    }
    
    if ([text isEqualToString:@"永久切换到正式版"]) {
        [NSUserDefaults.standardUserDefaults setBool:YES forKey:mDisableState];
        [mNotificationCenter postNotificationName:MAGSwitchFormalStateNotification object:nil];
        return;
    }
    
    if ([text isEqualToString:@"APP当前版本号"]) {
        [self presentViewControllerWithObj:mAppVersion];
        return;
    }
    
    if ([text isEqualToString:@"提交日期"]) {
#ifdef Submission_Date
        [self presentViewControllerWithObj:Submission_Date];
#endif
    }
    
    if ([text isEqualToString:@"过审日期"]) {
#ifdef Submission_Date
    #ifdef DELAY_DAYS
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        // 提交审核日期
        NSDate *submissionDate = [dateFormatter dateFromString:Submission_Date];
        // 预计审核成功日期
        NSDate *date = [[NSDate date] initWithTimeInterval:24 * 3600 * DELAY_DAYS sinceDate:submissionDate];
        [self presentViewControllerWithObj:[dateFormatter stringFromDate:date]];
    #endif
#endif
    }
    
    id obj = [self mp_parsingCustomCommand:text];
    if (obj == nil) {
        obj = @"命令无法执行";
    }
    [self presentViewControllerWithObj:obj];
}

+ (void)presentViewControllerWithObj:(id)obj {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:obj preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UIPasteboard generalPasteboard].string = obj ?: @"";
        [mMainWindow m_showSuccessHUDFromText:@"复制成功"];
    }];
    [alert addAction:sureAction];
    [alert addAction:copyAction];
    [mCurrentViewController presentViewController:alert animated:YES completion:nil];
}

/// 解析自定义的命令
+ (nullable id)mp_parsingCustomCommand:(NSString *)command {
    NSArray *array = [command componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@". "]];
    
    NSString *className = array.firstObject;
    Class class = NSClassFromString(className);
    if (class == nil) return nil;
    
    id obj = class;
    for (NSInteger i = 1; i < array.count; i++) {
        NSString *funString = array[i];
        id param = nil;
        if ([funString containsString:@":"]) {// 获取参数和方法名
            NSRange range = [funString rangeOfString:@":"];
            param = [funString substringFromIndex:range.location + range.length];
            funString = [funString substringToIndex:range.location + 1];
        }
        
        SEL funName = NSSelectorFromString(funString);
        if (![obj respondsToSelector:funName]) break;
        
        IMP imp = [obj methodForSelector:funName];
        id (*func)(id, SEL, id) = (void *)imp;
        obj = func(obj, funName, param);
    }
    
    return obj;
}

@end

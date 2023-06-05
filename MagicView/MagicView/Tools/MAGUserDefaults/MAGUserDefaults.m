//
//  MAGUserDefaults.m
//  iOSTE
//
//  Created by LL on 2021/9/3.
//

#import "MAGUserDefaults.h"

#import "MAGImport.h"

@implementation MAGUserDefaults

static dispatch_queue_t _magic_userDefault_queue;
+ (void)initialize {
    _magic_userDefault_queue = dispatch_queue_create("magic_userDefault_syncQueue", NULL);
    // 注册通知，当应用失去焦点或即将终止时将用户信息保存到本地
    [mNotificationCenter addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:NSOperationQueue.new usingBlock:^(NSNotification * _Nonnull note) {
        [self.userDefaults m_writeToFile:MAGFileManager.userDefaultsPath];
    }];
    [mNotificationCenter addObserverForName:UIApplicationWillTerminateNotification object:nil queue:NSOperationQueue.new usingBlock:^(NSNotification * _Nonnull note) {
        [self.userDefaults m_writeToFile:MAGFileManager.userDefaultsPath];
    }];
}

+ (NSMutableDictionary *)userDefaults {
    static NSMutableDictionary *_userDefaults;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userDefaults = [[NSDictionary m_dictionaryWithContentsOfFile:MAGFileManager.userDefaultsPath] mutableCopy];
        if (_userDefaults == nil) _userDefaults = [NSMutableDictionary dictionary];
    });
    return _userDefaults;
}

+ (nullable id)objectForKey:(NSString *)key {
    id __block temp;
    dispatch_sync(_magic_userDefault_queue, ^{
        temp = [self.userDefaults objectForKey:key];
    });
    return temp;
}

+ (void)setObject:(id _Nullable)object forKey:(NSString *)key {
    dispatch_barrier_async(_magic_userDefault_queue, ^{
        [self.userDefaults setValue:object forKey:key];
    });
}

+ (void)prompt_setObject:(id _Nullable)object forKey:(NSString *)key {
    dispatch_barrier_async(_magic_userDefault_queue, ^{
        [self.userDefaults setValue:object forKey:key];
        [self.userDefaults m_writeToFile:MAGFileManager.userDefaultsPath];
    });
}

+ (BOOL)boolForKey:(NSString *)key {
    return [[self objectForKey:key] boolValue];
}

+ (void)setBool:(BOOL)boolObj forKey:(NSString *)key {
    [self setObject:@(boolObj) forKey:key];
}

+ (NSInteger)integerForKey:(NSString *)key {
    return [[self objectForKey:key] integerValue];
}

+ (void)setInteger:(NSInteger)integerObj forKey:(NSString *)key {
    [self setObject:@(integerObj) forKey:key];
}

+ (CGFloat)floatForKey:(NSString *)key {
    return [[self objectForKey:key] floatValue];
}

+ (void)setFloat:(CGFloat)floatObj forKey:(NSString *)key {
    [self setObject:@(floatObj) forKey:key];
}

@end

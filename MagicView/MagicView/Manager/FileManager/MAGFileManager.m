//
//  MAGFileManager.m
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import "MAGFileManager.h"

#import "NSString+Magic.h"

@implementation MAGFileManager

+ (NSString *)documentPath {
    static NSString *documentPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"MAG"];
    });
    return documentPath;
}

+ (NSString *)libraryPath {
    static NSString *libraryPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"MAG"];
    });
    return libraryPath;
}

+ (NSString *)cachePath {
    static NSString *cachePath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"MAG"];
    });
    return cachePath;
}

+ (NSString *)tmpPath {
    static NSString *tmpPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tmpPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"MAG"];
    });
    return tmpPath;
}


#pragma mark - User
/// 用户文件夹路径
+ (NSString *)userFolderPath {
    static NSString *userFolderPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userFolderPath = [[self libraryPath] stringByAppendingPathComponent:@"User".m_optionalEncryption];
    });
    return userFolderPath;
}

/// 用户信息文件夹
+ (NSString *)userInfoFolderPath {
    static NSString *userInfoFolderPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfoFolderPath = [[self userFolderPath] stringByAppendingPathComponent:@"userInfo".m_optionalEncryption];
    });
    return userInfoFolderPath;
}

/// 根据唯一标识符获取用户信息文件
+ (NSString *)userInfoFilePath:(NSString *)token {
    return [[self userInfoFolderPath] stringByAppendingPathComponent:token.m_optionalEncryption];
}

+ (NSString *)userDefaultsPath {
    static NSString *userDefaultsPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userDefaultsPath = [[self userFolderPath] stringByAppendingPathComponent:@"userDefaults".m_optionalEncryption];
    });
    return userDefaultsPath;
}

+ (NSString *)accountPath {
    static NSString *accountPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accountPath = [[self userFolderPath] stringByAppendingPathComponent:@"account".m_optionalEncryption];
    });
    return accountPath;
}

#pragma mark BOOK
/// 小说文件夹路径
+ (NSString *)bookFolderPath {
    static NSString *bookFolderPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bookFolderPath = [[self userFolderPath] stringByAppendingPathComponent:@"BOOK".m_optionalEncryption];
    });
    return bookFolderPath;
}

/// 指定小说的文件夹路径
+ (NSString *)bookFolderWithBookID:(NSString *)bookID {
    return [[self bookFolderPath] stringByAppendingPathComponent:bookID.m_optionalEncryption];
}

/// 指定小说的阅读信息文件路径
+ (NSString *)bookReadInfoFilePathWithBookID:(NSString *)bookID {
    return [[self bookFolderWithBookID:bookID] stringByAppendingPathComponent:@"bookReadInfo".m_optionalEncryption];
}

/// 指定小说的目录文件路径
+ (NSString *)bookCatalogFilePathWithBookID:(NSString *)bookID {
    return [[self bookFolderWithBookID:bookID] stringByAppendingPathComponent:@"bookCatalog".m_optionalEncryption];
}

/// 小说阅读记录文件路径
+ (NSString *)bookReadingRecordFilePath {
    static NSString *bookReadingRecordFilePath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bookReadingRecordFilePath = [[self bookFolderPath] stringByAppendingPathComponent:@"bookReadingRecord".m_optionalEncryption];
    });
    return bookReadingRecordFilePath;
}

/// 小说收藏记录文件路径
+ (NSString *)bookCollectionRecordFilePath {
    static NSString *bookCollectionRecordFilePath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bookCollectionRecordFilePath = [[self bookFolderPath] stringByAppendingPathComponent:@"bookCollectionRecord".m_optionalEncryption];
    });
    return bookCollectionRecordFilePath;
}

/// 小说购买记录文件路径
+ (NSString *)bookPurchaseFilePath {
    static NSString *bookPurchaseFilePath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bookPurchaseFilePath = [[self bookFolderPath] stringByAppendingPathComponent:@"bookPurchase".m_optionalEncryption];
    });
    return bookPurchaseFilePath;
}

/// 小说书城接口数据缓存路径
+ (NSString *)bookMallCachePath {
    static NSString *bookMallCachePath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bookMallCachePath = [[self bookFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"bookMall"].m_optionalEncryption];
    });
    return bookMallCachePath;
}


#pragma mark IAP
/// IAP相关文件夹路径
+ (NSString *)IAPFolderPath {
    static NSString *IAPFolderPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        IAPFolderPath = [[self userFolderPath] stringByAppendingPathComponent:@"IAP".m_optionalEncryption];
    });
    return IAPFolderPath;
}

/// 充值记录文件路径
+ (NSString *)rechargeRecordFilePath {
    static NSString *goodsListFilePath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        goodsListFilePath = [[self IAPFolderPath] stringByAppendingPathComponent:@"rechargeRecord".m_optionalEncryption];
    });
    return goodsListFilePath;
}


#pragma mark - App
/// APP相关文件夹路径
+ (NSString *)appFolderPath {
    static NSString *appFolderPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appFolderPath = [[self libraryPath] stringByAppendingPathComponent:@"APP".m_optionalEncryption];
    });
    return appFolderPath;
}

/// 昵称文件夹路径
+ (NSString *)nicknameFolderPath {
    static NSString *nicknameFolderPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nicknameFolderPath = [[self appFolderPath] stringByAppendingPathComponent:@"nickname".m_optionalEncryption];
    });
    return nicknameFolderPath;
}

/// 中文昵称文件路径
+ (NSString *)chineseNicknameFilePath {
    static NSString *chineseNicknameFilePath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chineseNicknameFilePath = [[self nicknameFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", @"chineseNickname".m_optionalEncryption]];
    });
    return chineseNicknameFilePath;
}

/// 英文昵称文件路径
+ (NSString *)englishNicknameFilePath {
    static NSString *englishNicknameFilePath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        englishNicknameFilePath = [[self nicknameFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", @"englishNickname".m_optionalEncryption]];
    });
    return englishNicknameFilePath;
}


#pragma mark - Caches
/// URL接口缓存文件夹路径
+ (NSString *)URLRequestCacheFolderPath {
    static NSString *URLRequestCacheFolderPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        URLRequestCacheFolderPath = [[self cachePath] stringByAppendingPathComponent:@"URLRequestCache".m_optionalEncryption];
    });
    return URLRequestCacheFolderPath;
}

/// 小说文件夹缓存路径
+ (NSString *)bookFolderCachePath {
    static NSString *bookFolderCachePath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bookFolderCachePath = [[self cachePath] stringByAppendingPathComponent:@"BOOK".m_optionalEncryption];
    });
    return bookFolderCachePath;
}

/// 获取指定小说文件夹缓存路径
+ (NSString *)bookFolderCachePathWithBookID:(NSString *)bookID {
    return [[self bookFolderCachePath] stringByAppendingPathComponent:bookID.m_optionalEncryption];
}

/// 根据bookID和chapterID获取小说指定章节内容的保存路径
+ (NSString *)bookContentPathWithBookID:(NSString *)bookID chapterID:(NSString *)chapterID {
    return [[self bookFolderCachePathWithBookID:bookID] stringByAppendingPathComponent:chapterID.m_optionalEncryption];
}

@end

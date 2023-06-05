//
//  MAGFileManager.h
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 关于文件存储的结构可以查看工程根目录下的"壳沙盒结构.xmind"
@interface MAGFileManager : NSObject

/// 此文件夹会被iTunes和iCloud备份，
/// 可以通过文件共享使该目录的内容对用户可用。
+ (NSString *)documentPath;


/// 此文件夹会被iTunes和iCloud备份，
/// 用于存放您不希望向用户公开的文件。
+ (NSString *)libraryPath;


/// 此文件夹不会被iTunes和iCloud备份，
/// 系统可能会删除Caches/目录以释放磁盘空间，
/// 用于存放一些能重新创建或下载的文件。
+ (NSString *)cachePath;


/// 此文件夹不会被iTunes和iCloud备份，
/// 当APP未运行时，系统会定期清除tmp/下的文件，
/// 用于存放运行时产生的不重要的文件。
+ (NSString *)tmpPath;


#pragma mark - User
/// 用户文件夹路径
+ (NSString *)userFolderPath;

/// 用户信息文件夹
+ (NSString *)userInfoFolderPath;

/// 根据唯一标识符获取用户信息文件
+ (NSString *)userInfoFilePath:(NSString *)token;

+ (NSString *)userDefaultsPath;

/// 账号存储路径
+ (NSString *)accountPath;


#pragma mark BOOK
/// 小说文件夹路径
+ (NSString *)bookFolderPath;

/// 指定小说的文件夹路径
+ (NSString *)bookFolderWithBookID:(NSString *)bookID;

/// 指定小说的阅读信息文件路径
+ (NSString *)bookReadInfoFilePathWithBookID:(NSString *)bookID;

/// 指定小说的目录文件路径
+ (NSString *)bookCatalogFilePathWithBookID:(NSString *)bookID;

/// 小说阅读记录文件路径
+ (NSString *)bookReadingRecordFilePath;

/// 小说收藏记录文件路径
+ (NSString *)bookCollectionRecordFilePath;

/// 小说购买记录文件路径
+ (NSString *)bookPurchaseFilePath;

/// 小说书城接口数据缓存路径
/// @note 不同语言缓存路径不相同
+ (NSString *)bookMallCachePath;


#pragma mark IAP
/// IAP相关文件夹路径
+ (NSString *)IAPFolderPath;

/// 充值记录文件路径
+ (NSString *)rechargeRecordFilePath;


#pragma mark - App
/// APP相关文件夹路径
+ (NSString *)appFolderPath;

/// 昵称文件夹路径
+ (NSString *)nicknameFolderPath;

/// 中文昵称文件路径
+ (NSString *)chineseNicknameFilePath;

/// 英文昵称文件路径
+ (NSString *)englishNicknameFilePath;


#pragma mark - Caches
/// URL接口缓存文件夹路径
+ (NSString *)URLRequestCacheFolderPath;

/// 小说文件夹缓存路径
+ (NSString *)bookFolderCachePath;

/// 获取指定小说文件夹缓存路径
+ (NSString *)bookFolderCachePathWithBookID:(NSString *)bookID;

/// 根据bookID和chapterID获取小说指定章节内容的保存路径
+ (NSString *)bookContentPathWithBookID:(NSString *)bookID chapterID:(NSString *)chapterID;

@end

NS_ASSUME_NONNULL_END

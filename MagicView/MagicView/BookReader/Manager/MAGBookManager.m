//
//  MAGBookReaderManager.m
//  MagicView
//
//  Created by LL on 2021/7/16.
//

#import "MAGBookManager.h"

#import "MAGImport.h"

#import "MAGBookReaderManager.h"
#import "MAGBookDownloadManager.h"
#import "MAGBookRecordManager.h"
#import "MAGBookPageContentModel.h"
#import "MAGPurchaseManager.h"

/// 用于标记存在阅读记录但还未获取到章节内容，所以无法计算出页码的状态。
static NSInteger const mUninitializedPageIndexIdentifier = -999;

/// 章节最后一页的页码标识符
static NSInteger const mLastPageIndexIdentifier = -998;

@interface MAGBookManager ()

/// 翻页前的章节ID
@property (nonatomic, copy, nullable) NSString *oldChapterID;

/// 翻页前的章节索引
@property (nonatomic, assign) NSInteger oldChapterIndex;

/// 翻页前的页码索引
@property (nonatomic, assign) NSInteger oldPageIndex;

/// 开始阅读时的时间
@property (nonatomic, assign) NSInteger startingTime;

@property (nonatomic, strong) MAGBookDownloadManager *downloadManager;

@property (nonatomic, strong) MAGBookCatalogModel *bookCatalog;

/// 当前章节的每页内容数组
@property (nonatomic, copy) NSArray<MAGBookPageContentModel *> *pageContentArray;

/// 使用章节ID获取缓存的章节内容，如果获取到的是空字符串，则表示正在预加载中
@property (nonatomic, strong) NSCache *chapterCacheContent;

@end

@implementation MAGBookManager

- (void)dealloc {
    NSInteger readTime = mTimestampSecond - self.startingTime;
    self.readInfo.readTime += readTime;
    [self.readInfo removeObserverBlocks];
}

+ (nullable instancetype)bookManagerWithBookID:(NSString *)bookID {
    if (mObjectIsEmpty(bookID)) return nil;
    
    MAGBookManager *bookManager = [[self alloc] init];
    if (bookManager) {
        bookManager->_bookID = [bookID copy];
        [bookManager initialize];
    }
    
    return bookManager;
}

- (void)initialize {
    self.chapterCacheContent = [[NSCache alloc] init];
    self.chapterCacheContent.countLimit = 10;
    
    self.startingTime = mTimestampSecond;
    
    self->_readInfo = [MAGBookRecordManager readInfoWihthBookID:self.bookID];
    if (self.readInfo.pageContent) {
        self.readInfo.pageIndex = mUninitializedPageIndexIdentifier;
    }
    
    mWeakobj(self)
    {// 保存上一次的阅读记录信息
        [self.readInfo addObserverBlockForKeyPath:mKEYPATH(self.readInfo, chapterID) block:^(id  _Nonnull obj, id _Nullable oldVal, id _Nullable newVal) {
            weak_self.oldChapterID = oldVal;
        }];
        
        [self.readInfo addObserverBlockForKeyPath:mKEYPATH(self.readInfo, chapterIndex) block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
            weak_self.oldChapterIndex = [oldVal integerValue];
        }];
        
        [self.readInfo addObserverBlockForKeyPath:mKEYPATH(self.readInfo, pageIndex) block:^(MAGBookReadModel * _Nonnull readInfo, id  _Nullable oldVal, id  _Nullable newVal) {
            weak_self.oldPageIndex = [oldVal integerValue];
            
            NSInteger pageIndex = [newVal integerValue];
            MAGBookPageContentModel *pageContent = [weak_self.pageContentArray objectOrNilAtIndex:pageIndex];
            readInfo.pageContent = pageContent.content;
        }];
    }
    
    self.downloadManager = [MAGBookDownloadManager bookDownloadManagerWithBookID:self.bookID];
    self.downloadManager.bookCatalogDidChange = ^(MAGBookCatalogModel * _Nonnull catalogModel) {
        weak_self.bookCatalog = catalogModel;
        if (weak_self) {
            mStrongobj(weak_self)
            strong_weak_self->_bookCover = [catalogModel.bookCover copy];
        }
    };
}

- (void)getCurrentPageContent:(mBookPageContentBlock)block autoUpdate:(BOOL)autoUpdate {
    [self getPageContentWithChapterIndex:self.readInfo.chapterIndex pageIndex:self.readInfo.pageIndex complte:block autoUpdate:autoUpdate];
}

- (void)getAfterPageContent:(mBookPageContentBlock)block autoUpdate:(BOOL)autoUpdate {
    // 首先判断当前是不是第一页
    if ([self isFirstPage]) {
        [mMainWindow m_showErrorHUDFromText:@"没有上一页了"];
        !block ?: block(nil);
        return;
    }
    
    // 判断当前章节有没有上一页
    MAGBookPageContentModel *pageContent = [self.pageContentArray objectOrNilAtIndex:self.readInfo.pageIndex - 1];
    if (pageContent) {
        if (autoUpdate) {
            self.readInfo.pageIndex -= 1;
        }
        !block ?: block(pageContent);
        return;
    }
    
    // 翻到了上一章
    MAGBookChapterContentModel *chapterContent = [self mp_getChapterCacheContentWithChapterID:nil chapterIndex:self.readInfo.chapterIndex - 1];
    if (chapterContent) {
        MAGBookPageContentModel *pageContent = [self mp_parsingChapterContent:chapterContent pageIndex:mLastPageIndexIdentifier autoUpdate:YES];
        !block ?: block(pageContent);
    } else {
        [self getPageContentWithChapterIndex:self.readInfo.chapterIndex - 1 pageIndex:mLastPageIndexIdentifier complte:block autoUpdate:autoUpdate];
    }
}

- (void)getBeforePageContent:(mBookPageContentBlock)block autoUpdate:(BOOL)autoUpdate {
    // 首先判断当前是不是最后一页
    if ([self isLastPage]) {
        [mMainWindow m_showErrorHUDFromText:@"没有下一页了"];
        !block ?: block(nil);
        return;
    }
    
    // 判断当前章节有没有下一页
    MAGBookPageContentModel *pageContent = [self.pageContentArray objectOrNilAtIndex:self.readInfo.pageIndex + 1];
    if (pageContent) {
        if (autoUpdate) {
            self.readInfo.pageIndex += 1;
        }
        !block ?: block(pageContent);
        return;
    }

    // 翻到了下一章
    MAGBookChapterContentModel *chapterContent = [self mp_getChapterCacheContentWithChapterID:nil chapterIndex:self.readInfo.chapterIndex + 1];
    if (chapterContent) {
        MAGBookPageContentModel *pageContent = [self mp_parsingChapterContent:chapterContent pageIndex:0 autoUpdate:YES];
        !block ?: block(pageContent);
    } else {
        [self getPageContentWithChapterIndex:self.readInfo.chapterIndex + 1 pageIndex:0 complte:block autoUpdate:autoUpdate];
    }
}

- (void)getPageContentWithChapterIndex:(NSInteger)chapterIndex pageIndex:(NSInteger)pageIndex complte:(mBookPageContentBlock)block autoUpdate:(BOOL)autoUpdate {
    mWeakobj(self)
    [self.downloadManager getChapterContentWithChapterIndex:chapterIndex complete:^(MAGBookChapterContentModel * _Nullable chapterContent) {
        if (chapterContent == nil) {
            !block ?: block(nil);
            return;
        }
        
        MAGBookPageContentModel *pageContent = [weak_self mp_parsingChapterContent:chapterContent pageIndex:pageIndex autoUpdate:autoUpdate];
        !block ?: block(pageContent);
    }];
}

- (void)getPageContentWithChapterID:(NSString *)chapterID pageIndex:(NSInteger)pageIndex complte:(mBookPageContentBlock)block autoUpdate:(BOOL)autoUpdate {
    mWeakobj(self)
    [self.downloadManager getChapterContentWithChapterID:chapterID complete:^(MAGBookChapterContentModel * _Nullable chapterContent) {
        if (chapterContent == nil) {
            !block ?: block(nil);
            return;
        }
        
        MAGBookPageContentModel *pageContent = [weak_self mp_parsingChapterContent:chapterContent pageIndex:pageIndex autoUpdate:autoUpdate];
        !block ?: block(pageContent);
    }];
}

- (nullable MAGBookPageContentModel *)getCurrentPageContentWithAutoUpdate:(BOOL)autoUpdate {
    return [self getPageContentWithChapterIndex:self.readInfo.chapterIndex pageIndex:self.readInfo.pageIndex autoUpdate:NO];
}

- (nullable MAGBookPageContentModel *)getAfterPageContentWithAutoUpdate:(BOOL)autoUpdate {
    // 首先判断当前是不是第一页
    if ([self isFirstPage]) {
        [mMainWindow m_showErrorHUDFromText:@"没有上一页了"];
        return nil;
    }
    
    // 判断当前章节有没有上一页
    MAGBookPageContentModel *pageContent = [self.pageContentArray objectOrNilAtIndex:self.readInfo.pageIndex - 1];
    if (pageContent) {
        if (autoUpdate) {
            self.readInfo.pageIndex -= 1;
        }
        return pageContent;
    }

    // 翻到了上一章
    MAGBookChapterContentModel *chapterContent = [self mp_getChapterCacheContentWithChapterID:nil chapterIndex:self.readInfo.chapterIndex - 1];
    if (chapterContent) {
        return [self mp_parsingChapterContent:chapterContent pageIndex:mLastPageIndexIdentifier autoUpdate:autoUpdate];
    } else {
        return [self getPageContentWithChapterIndex:self.readInfo.chapterIndex - 1 pageIndex:mLastPageIndexIdentifier autoUpdate:autoUpdate];
    }
}

- (nullable MAGBookPageContentModel *)getBeforePageContentWithAutoUpdate:(BOOL)autoUpdate {
    // 首先判断当前是不是最后一页
    if ([self isLastPage]) {
        [mMainWindow m_showErrorHUDFromText:@"没有下一页了"];
        return nil;
    }
    
    // 判断当前章节有没有下一页
    MAGBookPageContentModel *pageContent = [self.pageContentArray objectOrNilAtIndex:self.readInfo.pageIndex + 1];
    if (pageContent) {
        if (autoUpdate) {
            self.readInfo.pageIndex += 1;
        }
        return pageContent;
    }

    // 翻到了下一章
    MAGBookChapterContentModel *chapterContent = [self mp_getChapterCacheContentWithChapterID:nil chapterIndex:self.readInfo.chapterIndex + 1];
    if (chapterContent) {
        return [self mp_parsingChapterContent:chapterContent pageIndex:0 autoUpdate:autoUpdate];
    } else {
        return [self getPageContentWithChapterIndex:self.readInfo.chapterIndex + 1 pageIndex:0 autoUpdate:autoUpdate];
    }
}

- (nullable MAGBookPageContentModel *)getPageContentWithChapterID:(NSString *)chapterID pageIndex:(NSInteger)pageIndex autoUpdate:(BOOL)autoUpdate {
    MAGBookChapterContentModel *chapterContent = [self.downloadManager getChapterContentWithChapterID:chapterID];
    if (chapterContent == nil) return nil;
    
    return [self mp_parsingChapterContent:chapterContent pageIndex:pageIndex autoUpdate:autoUpdate];
}

- (nullable MAGBookPageContentModel *)getPageContentWithChapterIndex:(NSInteger)chapterIndex pageIndex:(NSInteger)pageIndex autoUpdate:(BOOL)autoUpdate {
    MAGBookChapterContentModel *chapterContent = [self.downloadManager getChapterContentWithChapterIndex:chapterIndex];
    if (chapterContent == nil) return nil;
    
    return [self mp_parsingChapterContent:chapterContent pageIndex:pageIndex autoUpdate:autoUpdate];
}

- (NSArray<NSString *> *)listenStrings {
    NSMutableArray<NSString *> *textArray = [NSMutableArray array];
    for (MAGBookPageContentModel *page in self.pageContentArray) {
        [textArray addObject:page.content ?: @""];
    }
    return [textArray copy];
}

- (void)cancelTurnPage {
    self.readInfo.chapterID = self.oldChapterID;
    self.readInfo.chapterIndex = self.oldChapterIndex;
    self.readInfo.pageIndex = self.oldPageIndex;
}

- (BOOL)isFirstPage {
    return (self.readInfo.chapterIndex == 0 && self.readInfo.pageIndex == 0);
}

- (BOOL)isLastPage {
    BOOL isLastChapter = self.readInfo.chapterIndex == self.bookCatalog.count - 1;
    BOOL isLastPage = self.readInfo.pageIndex == self.pageContentArray.count - 1;
    return isLastChapter && isLastPage;
}


#pragma mark - Private
/// 解析章节Model并返回指定页内容
/// @param chapterContent 章节Model
/// @param pageIndex 页码
/// @param autoUpdate 是否自动更新阅读记录
- (nullable MAGBookPageContentModel *)mp_parsingChapterContent:(MAGBookChapterContentModel *)chapterContent pageIndex:(NSInteger)pageIndex autoUpdate:(BOOL)autoUpdate {
    // 预加载下一章的内容
    [self mp_preloadChapterContentWithChapterID:chapterContent.nextChapterID];
    
    // 预加载上一章的内容
    [self mp_preloadChapterContentWithChapterID:chapterContent.previousChapterID];
    
    NSArray *t_array = [self mp_parsingChapterContent:chapterContent pageIndex:pageIndex];
    if (t_array == nil) return nil;
    
    NSArray<NSAttributedString *> *chapterAttributedStringArray = t_array.firstObject;
    MAGBookPageContentModel *pageContent = t_array.lastObject;
    
    if (autoUpdate) {
        self.pageContentArray = [self mp_createPageContent:chapterAttributedStringArray chapterContent:chapterContent];
        self->_bookName = [chapterContent.book.name copy];
        self.readInfo.chapterIndex = chapterContent.realIndex;
        self.readInfo.chapterID = chapterContent.chapterID;
        self.readInfo.chapterTitle = chapterContent.title;
        self.readInfo.pageIndex = pageContent.pageIndex;
        self.readInfo.chapterPages = self.pageContentArray.count;
        self->_chapterCount = self.bookCatalog.count;
    }
    
    return pageContent;
}

/// 将每一页的富文本内容转换成每一页显示的Model
/// @param attributedStringArray 需要转换的富文本
/// @param chapterContent 章节内容
- (NSArray<MAGBookPageContentModel *> *)mp_createPageContent:(NSArray<NSAttributedString *> *)attributedStringArray chapterContent:(MAGBookChapterContentModel *)chapterContent {
    NSMutableArray<MAGBookPageContentModel *> *t_array = [NSMutableArray array];
    [attributedStringArray enumerateObjectsUsingBlock:^(NSAttributedString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MAGBookPageContentModel *pageContent = [self createPageContentBasedOnChapterContent:chapterContent];
        pageContent.attributedString = obj;
        pageContent.content = obj.string;
        pageContent.pageIndex = idx;
        pageContent.chapterPages = attributedStringArray.count;
        [t_array addObject:pageContent];
    }];
    
    return [t_array copy];
}

/// 返回一个数组，第一个元素是这一章的富文本数组，第二个元素是MAGBookPageContentModel
- (nullable NSArray *)mp_parsingChapterContent:(MAGBookChapterContentModel *)chapterContent pageIndex:(NSInteger)pageIndex {
    if (mObjectIsEmpty(chapterContent.content)) return nil;
    
    NSArray<NSAttributedString *> *chapterAttributedStringArray = [self mp_parsingChapterAttributedString:chapterContent];
    
    NSInteger _pageIndex = pageIndex;
    if (pageIndex == mUninitializedPageIndexIdentifier) {
        _pageIndex = [self mp_calculatePageIndexWithAttributedStringArray:chapterAttributedStringArray];
    } else if (pageIndex == mLastPageIndexIdentifier) {
        _pageIndex = chapterAttributedStringArray.count - 1;
    }
    
    MAGBookPageContentModel *pageContent = [self createPageContentBasedOnChapterContent:chapterContent];
    pageContent.attributedString = chapterAttributedStringArray[_pageIndex];
    pageContent.content = pageContent.attributedString.string;
    pageContent.pageIndex = _pageIndex;
    pageContent.chapterPages = chapterAttributedStringArray.count;
    
    return @[chapterAttributedStringArray, pageContent];
}

/// 根据 chapterContent 创建 pageContent
- (MAGBookPageContentModel *)createPageContentBasedOnChapterContent:(MAGBookChapterContentModel *)chapterContent {
    MAGBookPageContentModel *pageContent = [[MAGBookPageContentModel alloc] init];
    pageContent.bookID = self.bookID;
    pageContent.bookName = chapterContent.book.name;
    pageContent.chapterTitle = chapterContent.title;
    pageContent.chapterID = chapterContent.chapterID;
    pageContent.chapterIndex = chapterContent.realIndex;
    pageContent.chapterCount = self.bookCatalog.count;
    
    return pageContent;
}

/// 将章节内容解析为富文本数组
- (NSArray<NSAttributedString *> *)mp_parsingChapterAttributedString:(MAGBookChapterContentModel *)chapterContent {
    // 章节全部内容富文本
    NSMutableAttributedString *chapterAttributedString = [[NSMutableAttributedString alloc] init];
    
    // 标题富文本
    NSAttributedString *titleAttributedString = [[NSAttributedString alloc] initWithString:chapterContent.title ?: @""
                                                                                attributes:@{NSFontAttributeName : MAGBookReaderManager.readerTitleFont}];
    
    // 章节内容富文本
    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithString:chapterContent.content ?: @""
                                                                                         attributes:@{NSFontAttributeName : MAGBookReaderManager.readerTextFont}];
    // 如果服务端没返回换行符，则手动插入换行符
    if (![chapterContent.content isEqualToString:mBookNoDataIdentifier] && ![contentAttributedString.string hasPrefix:@"\n"]) {
        [contentAttributedString insertString:@"\n\n" atIndex:0];
    }
    
    [chapterAttributedString appendAttributedString:titleAttributedString];
    [chapterAttributedString appendAttributedString:contentAttributedString];
    
    chapterAttributedString.lineSpacing = MAGBookReaderManager.lineSpacing;
    chapterAttributedString.paragraphSpacing = MAGBookReaderManager.lineSpacing * 2;
    
    if (chapterContent.localCanRead) {
        return [chapterAttributedString m_componentsSeparatedBySize:MAGBookReaderManager.bookContentFrame.size];
    } else {
        CGSize separatedSize = MAGBookReaderManager.bookContentFrame.size;
        separatedSize.height = separatedSize.height / 2.0;
        return @[[chapterAttributedString m_separatedBySize:separatedSize] ?: [NSAttributedString new]];
    }
}

/// 预加载章节内容
- (void)mp_preloadChapterContentWithChapterID:(NSString *)chapterID {
    if (mObjectIsEmpty(chapterID)) return;
    if ([chapterID integerValue] == 0) return;
    if ([self.chapterCacheContent objectForKey:chapterID]) return;
    
    /// 标记为正在预加载
    [self.chapterCacheContent setObject:@"" forKey:chapterID];
    
    mWeakobj(self)
    [self.downloadManager getChapterContentWithChapterID:chapterID complete:^(MAGBookChapterContentModel * _Nullable contentModel) {
        if (contentModel == nil) return;
        [weak_self.chapterCacheContent setObject:contentModel forKey:chapterID];
    }];
}

/// 根据 chapterID 或 chapterIndex 获取缓存的章节内容
/// @discussion 2者不能都为空，优先用 chapterID 查找缓存内容
- (nullable MAGBookChapterContentModel *)mp_getChapterCacheContentWithChapterID:(NSString * _Nullable)chapterID chapterIndex:(NSInteger)chapterIndex {
    MAGBookChapterContentModel *chapterContent = nil;
    if (chapterID) {
        chapterContent = [self.chapterCacheContent objectForKey:chapterID];
    } else {
        MAGBookCatalogListModel *catalogModel = [self.bookCatalog.list objectOrNilAtIndex:chapterIndex];
        chapterContent = [self.chapterCacheContent objectForKey:catalogModel.chapterID];
    }
    
    if (![chapterContent isMemberOfClass:MAGBookChapterContentModel.class]) return nil;
    return chapterContent;
}

/// 计算实时页码
- (NSUInteger)mp_calculatePageIndexWithAttributedStringArray:(NSArray<NSAttributedString *> *)attributedStringArray {
    NSString *content = self.readInfo.pageContent;
    
    if (mObjectIsEmpty(content)) return 0;
    if (mObjectIsEmpty(attributedStringArray)) return 0;
    
    NSMutableString *mutableString = [NSMutableString string];
    for (NSAttributedString *obj in attributedStringArray) {
        [mutableString appendString:obj.string];
    }
    
    NSRange contentRange = [mutableString rangeOfString:content];
    if (NSMaxRange(contentRange) >= mutableString.length) return 0;
    
    NSInteger __block pageIndex = 0;
    NSInteger __block loc = 0;
    
    [attributedStringArray enumerateObjectsUsingBlock:^(NSAttributedString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange t_range = NSMakeRange(loc, obj.length);
        if (contentRange.location < NSMaxRange(t_range)) {
            pageIndex = idx;
            *stop = YES;
        }
        loc = NSMaxRange(t_range);
    }];
    
    return pageIndex;
}

@end

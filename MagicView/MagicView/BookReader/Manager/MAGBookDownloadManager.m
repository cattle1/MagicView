//
//  MAGBookDownloadManager.m
//  MagicView
//
//  Created by LL on 2021/8/27.
//

#import "MAGBookDownloadManager.h"

#import "MAGImport.h"
#import "MAGNetworkRequestManager.h"

@interface MAGBookDownloadManager ()

@property (nonatomic, readwrite, nullable) MAGBookCatalogModel *bookCatalog;

@end

@implementation MAGBookDownloadManager

+ (nullable instancetype)bookDownloadManagerWithBookID:(NSString *)bookID {
    if (mObjectIsEmpty(bookID)) return nil;
    
    MAGBookDownloadManager *downloadManager = [[self alloc] init];
    if (downloadManager) {
        downloadManager->_bookID = [bookID copy];
        [downloadManager initialize];
    }
    return downloadManager;
}

- (void)initialize {
    NSString *bookCatalogPath = [MAGFileManager bookCatalogFilePathWithBookID:self.bookID];
    NSDictionary *bookCatalogDict = [NSDictionary m_dictionaryWithContentsOfFile:bookCatalogPath];
    self.bookCatalog = [MAGBookCatalogModel modelWithDictionary:bookCatalogDict];
    
    if (self.bookCatalog == nil || self.bookCatalog.list.count < self.bookCatalog.count) {
        [self mp_requestFullCatalog];
    }
}

- (void)setBookCatalogDidChange:(void (^)(MAGBookCatalogModel * _Nonnull))bookCatalogDidChange {
    _bookCatalogDidChange = bookCatalogDidChange;
    
    if (self.bookCatalog) {
        !self.bookCatalogDidChange ?: self.bookCatalogDidChange(self.bookCatalog);
    }
}


- (void)getChapterContentWithChapterID:(NSString *)chapterID complete:(mBookContentCompleteBlock)complete {
    if (mObjectIsEmpty(chapterID)) {
        mDispatchAsyncOnMainQueue(!complete ?: complete([MAGBookChapterContentModel emptyChapterContent]));
        return;
    }
    
    MAGBookChapterContentModel *localContentModel = [self getChapterContentWithChapterID:chapterID];
    if (localContentModel) {
        mDispatchAsyncOnMainQueue(!complete ?: complete(localContentModel));
        return;
    }
    
    [self mp_downloadChapterContentWithChapterID:chapterID complete:^(MAGBookChapterContentModel * _Nullable contentModel, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentModel) {
                !complete ?: complete(contentModel);
            } else {
                !complete ?: complete([MAGBookChapterContentModel emptyChapterContent]);
            }
        });
    }];
}

- (void)getChapterContentWithChapterIndex:(NSUInteger)chapterIndex complete:(mBookContentCompleteBlock)complete {
    MAGBookChapterContentModel *localContentModel = [self getChapterContentWithChapterIndex:chapterIndex];
    if (localContentModel) {
        mDispatchAsyncOnMainQueue(!complete ?: complete(localContentModel));
        return;
    }
    
    // 请求的章节索引不在目录列表中
    if (self.bookCatalog && chapterIndex >= self.bookCatalog.count) {
        mDispatchAsyncOnMainQueue(!complete ?: complete([MAGBookChapterContentModel emptyChapterContent]));
        return;
    }
    
    if (chapterIndex < self.bookCatalog.list.count) {
        MAGBookCatalogListModel *catalogModel = self.bookCatalog.list[chapterIndex];
        [self getChapterContentWithChapterID:catalogModel.chapterID complete:complete];
    } else {
        mWeakobj(self)
        NSString *chapterID = self.bookCatalog.list.firstObject.chapterID;
        // 获取新的分页目录
        [self mp_requestPaginationCatalogWithChapterID:chapterID complete:^(MAGBookCatalogModel * _Nullable bookCatalog, NSError * _Nullable error) {
            if (error) {
                mDispatchAsyncOnMainQueue(!complete ?: complete([MAGBookChapterContentModel emptyChapterContent]));
            } else {
                [weak_self getChapterContentWithChapterIndex:chapterIndex complete:complete];
            }
        }];
    }
}

- (nullable MAGBookChapterContentModel *)getChapterContentWithChapterID:(NSString *)chapterID {    
    NSString *chapterContentPath = [MAGFileManager bookContentPathWithBookID:self.bookID chapterID:chapterID];
    NSDictionary *chapterContentDict = [NSDictionary m_dictionaryWithContentsOfFile:chapterContentPath];
    MAGBookChapterContentModel *chapterContentModel = [MAGBookChapterContentModel modelWithDictionary:chapterContentDict];
    if (chapterContentModel == nil) return nil;
    
    MAGBookCatalogListModel *catalogModel = [self.bookCatalog.list objectOrNilAtIndex:chapterContentModel.realIndex];
    if (catalogModel == nil) return chapterContentModel;
    
    // 判断章节内容是否有更新
    if (chapterContentModel.updateTime == catalogModel.updateTime) {
        return chapterContentModel;
    } else {
        [mFileManager removeItemAtPath:chapterContentPath error:nil];
        return nil;
    }
}

- (nullable MAGBookChapterContentModel *)getChapterContentWithChapterIndex:(NSUInteger)chapterIndex {
    if (chapterIndex >= self.bookCatalog.list.count) return nil;
    
    MAGBookCatalogListModel *catalogModel = self.bookCatalog.list[chapterIndex];
    return [self getChapterContentWithChapterID:catalogModel.chapterID];
}


#pragma mark - Private
/// 获取分页目录数据
- (void)mp_requestPaginationCatalogWithChapterID:(nullable NSString *)chapterID complete:(void (^)(MAGBookCatalogModel * _Nullable bookCatalog, NSError * _Nullable error))complete {
    mWeakobj(self)
    [MAGNetworkRequestManager POST:mBookPaginationCatalogLink
                        parameters:@{@"book_id" : self.bookID, @"chapter_id" : chapterID ?: @""}
                        modelClass:MAGBookCatalogModel.class
                         needCache:NO
                       autoRequest:NO
                   completionQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                           success:^(BOOL isSuccess, MAGBookCatalogModel * _Nullable t_model, BOOL isCache, MAGNetworkRequestModel * _Nonnull requestModel) {
        if (isSuccess) {
            if (weak_self.bookCatalog) {
                // 判断所请求的目录是否被当前目录包含，
                // 如果包含则更新目录区间，如果不存在则追加在后面
                NSMutableArray<MAGBookCatalogListModel *> *catalogList = [weak_self.bookCatalog.list mutableCopy];
                NSInteger startIndex = t_model.list.firstObject.realIndex;
                if (startIndex + t_model.list.count < weak_self.bookCatalog.list.count) {
                    [catalogList replaceObjectsInRange:NSMakeRange(startIndex, t_model.list.count) withObjectsFromArray:t_model.list];
                } else {
                    [catalogList addObjectsFromArray:t_model.list];
                }
                weak_self.bookCatalog.list = [catalogList copy];
                weak_self.bookCatalog.author = t_model.author;
            } else {
                weak_self.bookCatalog = t_model;
            }
            
            !complete ?: complete(weak_self.bookCatalog, nil);
            
            [weak_self mp_updateLocalBookCatalog];
        } else {
            !complete ?: complete(nil, [NSError m_errorWithDescription:requestModel.msg ?: @"下载失败"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !complete ?: complete(nil, error);
    }];
}

/// 根据chapterID从网络下载章节数据
- (void)mp_downloadChapterContentWithChapterID:(NSString *)chapterID complete:(void (^)(MAGBookChapterContentModel * _Nullable contentModel, NSError * _Nullable error))complete {
    if (mObjectIsEmpty(chapterID)) {
        !complete ?: complete(nil, [NSError m_errorWithDescription:@"下载失败"]);
        return;
    }
    
    [MAGNetworkRequestManager POST:mBookChapterContentLink
                        parameters:@{@"book_id" : self.bookID, @"chapter_id" : chapterID}
                        modelClass:MAGBookChapterContentModel.class
                         needCache:NO
                       autoRequest:NO
                   completionQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                           success:^(BOOL isSuccess, MAGBookChapterContentModel * _Nullable t_model, BOOL isCache, MAGNetworkRequestModel * _Nonnull requestModel) {
        if (isSuccess) {
            !complete ?: complete(t_model, nil);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                NSString *chapterContentPath = [MAGFileManager bookContentPathWithBookID:self.bookID chapterID:chapterID];
                [requestModel.data m_writeToFile:chapterContentPath];
            });
        } else {
            !complete ?: complete(nil, [NSError m_errorWithDescription:requestModel.msg ?: @"下载失败"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !complete ?: complete(nil, error);
    }];
}

/// 获取全量目录
- (void)mp_requestFullCatalog {
    mWeakobj(self)    
    [MAGNetworkRequestManager POST:mBookFullCatalogLink
                        parameters:@{@"book_id" : self.bookID}
                        modelClass:MAGBookCatalogModel.class
                         needCache:NO
                       autoRequest:NO
                   completionQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                           success:^(BOOL isSuccess, MAGBookCatalogModel * _Nullable t_model, BOOL isCache, MAGNetworkRequestModel * _Nonnull requestModel) {
        if (isSuccess) {
            if (weak_self.bookCatalog) {
                weak_self.bookCatalog.list = t_model.list;
                weak_self.bookCatalog.count = t_model.count;
                weak_self.bookCatalog.bookName = t_model.bookName;
                weak_self.bookCatalog.bookCover = t_model.bookCover;
                weak_self.bookCatalog.bookDescription = t_model.bookDescription;
            } else {
                weak_self.bookCatalog = t_model;
            }
            
            [weak_self mp_updateLocalBookCatalog];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

/// 更新本地目录
- (void)mp_updateLocalBookCatalog {
    !self.bookCatalogDidChange ?: self.bookCatalogDidChange(self.bookCatalog);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self.bookCatalog m_writeToFile:[MAGFileManager bookCatalogFilePathWithBookID:self.bookID]];
    });
}

@end

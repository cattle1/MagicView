//
//  MAGBookRecordManager.m
//  MagicView
//
//  Created by LL on 2021/7/9.
//

#import "MAGBookRecordManager.h"

#import "MAGImport.h"

@implementation MAGBookRecordManager

static NSMutableArray<MAGBookModel *> *_bookReadRecord;
static NSMutableArray<MAGBookModel *> *_bookCollectionRecord;
static NSMutableDictionary<NSString *, MAGBookReadModel *> *_readInfoDictionay;

+ (void)initialize {
    // 读取本地的小说阅读记录
    _bookReadRecord = ({
        NSArray<NSDictionary *> *bookReadRecordArray = [NSArray m_arrayWithContentsOfFile:MAGFileManager.bookReadingRecordFilePath];
        _bookReadRecord = [[NSArray modelArrayWithClass:MAGBookModel.class json:bookReadRecordArray] mutableCopy];
        if (_bookReadRecord == nil) _bookReadRecord = [NSMutableArray array];
        _bookReadRecord;
    });
    
    // 读取本地的小说收藏列表
    _bookCollectionRecord = ({
        NSArray<NSDictionary *> *bookCollectionRecord = [NSArray m_arrayWithContentsOfFile:MAGFileManager.bookCollectionRecordFilePath];
        _bookCollectionRecord = [[NSArray modelArrayWithClass:MAGBookModel.class json:bookCollectionRecord] mutableCopy];
        if (_bookCollectionRecord == nil) _bookCollectionRecord = [NSMutableArray array];
        _bookCollectionRecord;
    });
    
    _readInfoDictionay = [NSMutableDictionary dictionary];
    
    [self m_addNotificationWithName:UIApplicationWillResignActiveNotification selector:@selector(appWillResignActiveNotification)];
}


+ (NSInteger)readTime {
    NSInteger readTime = 0;
    for (MAGBookModel *bookModel in _bookReadRecord) {
        MAGBookReadModel *readModel = [MAGBookReadModel bookReadWithBookID:bookModel.book_id];
        readTime += readModel.readTime;
    }
    return readTime;
}

+ (NSArray<MAGBookModel *> *)readingRecord {
    return _bookReadRecord;
}

+ (NSArray<MAGBookModel *> *)collectionRecord {
    return _bookCollectionRecord;
}

+ (NSInteger)readTimeWithBookID:(NSString *)bookID {
    MAGBookReadModel *readModel = [MAGBookReadModel bookReadWithBookID:bookID];
    return readModel.readTime;
}

+ (BOOL)haveReadWithBookID:(NSString *)bookID {
    MAGBookModel *bookModel = [[MAGBookModel alloc] init];
    bookModel.book_id = bookID;

    return [_bookReadRecord containsObject:bookModel];
}

+ (void)addReadRecordWithBookModel:(MAGBookModel *)bookModel {
    if (bookModel == nil) return;
    
    if ([_bookReadRecord containsObject:bookModel]) {
        [_bookReadRecord removeObject:bookModel];
    }
    [_bookReadRecord insertObject:bookModel atIndex:0];
}

+ (void)removeReadRecordWithBookID:(NSString *)bookID {
    MAGBookModel *bookModel = [[MAGBookModel alloc] init];
    bookModel.book_id = bookID;
    
    [_bookReadRecord removeObject:bookModel];
}

+ (BOOL)haveCollectWithBookID:(NSString *)bookID {
    MAGBookModel *bookModel = [[MAGBookModel alloc] init];
    bookModel.book_id = bookID;
    
    return [_bookCollectionRecord containsObject:bookModel];
}

+ (void)addCollectWithBookModel:(MAGBookModel *)bookModel {
    if (bookModel == nil) return;
    
    [_bookCollectionRecord insertObject:bookModel atIndex:0];
    [MAGClickAgent event:@"用户将小说加入书架" attributes:@{@"book_id" : bookModel.book_id, @"book_name" : bookModel.name ?: @"NULL"}];
}

+ (void)removeCollectWithBookID:(NSString *)bookID {
    MAGBookModel *tmpModel = [[MAGBookModel alloc] init];
    tmpModel.book_id = bookID;
    
    NSUInteger index = [_bookCollectionRecord indexOfObject:tmpModel];
    MAGBookModel *bookModel = [_bookCollectionRecord objectOrNilAtIndex:index];
    if (bookModel) {
        [_bookCollectionRecord removeObjectAtIndex:index];
    }
    [MAGClickAgent event:@"用户将小说从书架移出" attributes:@{@"book_id" : bookID ?: @"NULL", @"book_name" : bookModel.name ?: @"NULL"}];
}

+ (MAGBookReadModel *)readInfoWihthBookID:(NSString *)bookID {
    if ([_readInfoDictionay containsObjectForKey:bookID]) {
        return _readInfoDictionay[bookID];
    }
    
    MAGBookReadModel *readInfo = [MAGBookReadModel bookReadWithBookID:bookID];
    [_readInfoDictionay setObject:readInfo forKey:bookID];
    return readInfo;
}


#pragma mark - Notification
+ (void)appWillResignActiveNotification {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_bookCollectionRecord m_writeToFile:MAGFileManager.bookCollectionRecordFilePath];
        
        [_bookReadRecord m_writeToFile:MAGFileManager.bookReadingRecordFilePath];
        
        for (NSString *bookID in _readInfoDictionay) {
            NSString *readInfoPath = [MAGFileManager bookReadInfoFilePathWithBookID:bookID];
            [_readInfoDictionay[bookID] m_writeToFile:readInfoPath];
        }
    });
}

@end

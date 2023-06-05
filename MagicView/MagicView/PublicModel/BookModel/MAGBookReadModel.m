//
//  MAGBookReadModel.m
//  MagicView
//
//  Created by LL on 2021/9/9.
//

#import "MAGBookReadModel.h"

#import "MAGImport.h"

@implementation MAGBookReadModel

+ (instancetype)bookReadWithBookID:(NSString *)bookID {
    NSString *bookReadInfoPath = [MAGFileManager bookReadInfoFilePathWithBookID:bookID];
    NSDictionary *readInfoDictionary = [NSDictionary m_dictionaryWithContentsOfFile:bookReadInfoPath];
    if (readInfoDictionary == nil) return [self mp_bookReadWithBookID:bookID];
        
    return [MAGBookReadModel modelWithDictionary:readInfoDictionary];
}

+ (instancetype)mp_bookReadWithBookID:(NSString *)bookID {
    MAGBookReadModel *readModel = [[self alloc] init];
    readModel.bookID = bookID;
    return readModel;
}

- (NSUInteger)hash {
    return self.bookID.hash;
}

- (BOOL)isEqual:(MAGBookReadModel *)object {
    if (object == self) return YES;
    if (object == nil) return NO;
    if (![object isMemberOfClass:MAGBookReadModel.class]) return NO;
    
    return object.hash == self.hash;
}

@end

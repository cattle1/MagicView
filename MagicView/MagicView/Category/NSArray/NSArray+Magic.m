//
//  NSArray+Magic.m
//  MagicView
//
//  Created by LL on 2021/8/21.
//

#import "NSArray+Magic.h"

#import "MAGImport.h"

@implementation NSArray (Magic)

+ (NSArray *)m_arrayWithContentsOfFile:(NSString *)path {
    if (mObjectIsEmpty(path)) return nil;
    if (![mFileManager fileExistsAtPath:path]) return nil;
    
    NSData *decryptData = [NSData m_dataWithContentsOfFile:path];
    return decryptData.m_toArray;
}

+ (NSArray<NSString *> *)m_categoryArray {
    return @[
        @"异术", @"超能", @"热血", @"全能", @"爽文",
        @"嚣张", @"穿越", @"脑洞", @"万界", @"玄幻",
        @"轻松", @"搞笑", @"废柴", @"都市", @"年代",
        @"影视", @"励志", @"现实", @"无敌", @"逆袭",
        @"校园", @"丹药", @"鉴宝", @"修仙", @"霸气",
        @"强势", @"剑帝", @"悬疑", @"灵异", @"重生",
        @"浪漫", @"爱情", @"武侠", @"江湖", @"言情",
    ];
}

- (NSArray *)m_randomArray {
    if (self.count == 0) return self;
    
    NSMutableArray *t_array = [self mutableCopy];
    NSMutableArray *randomArray = [NSMutableArray array];
    
    while (t_array.count > 0) {
        NSInteger index = mRandomInteger(0, t_array.count - 1);
        [randomArray addObject:t_array[index]];
        [t_array removeObjectAtIndex:index];
    }
    
    return [randomArray copy];
}

@end


@implementation NSMutableArray (Magic)

+ (nullable NSMutableArray *)m_arrayWithContentsOfFile:(NSString *)path {
    return [[NSArray m_arrayWithContentsOfFile:path] mutableCopy];
}

@end

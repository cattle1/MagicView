//
//  MAGBookModel.h
//  MagicView
//
//  Created by LL on 2021/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAGBookModel : NSObject

@property (nonatomic, copy) NSString *book_id;

@property (nonatomic, copy, nullable) NSString *desc;

@property (nonatomic, copy, nullable) NSString *author;

@property (nonatomic, copy, nullable) NSString *cat;

@property (nonatomic, assign) NSInteger total_chapter;

@property (nonatomic, copy) NSString *cover;

@property (nonatomic, copy, nullable) NSString *name;

@end

NS_ASSUME_NONNULL_END

//
//  MAGBookChannelsDetailLabelModel.h
//  MagicView
//
//  Created by TSL on 2022/6/9.
//

#import <Foundation/Foundation.h>
#import "MAGBookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGBookChannelsDetailLabelModel : NSObject

@property (nonatomic, copy) NSString *recommend_id;

@property (nonatomic, copy) NSString *label;

@property (nonatomic, assign) NSInteger style;

@property (nonatomic, assign) BOOL can_refresh;

@property (nonatomic, assign) BOOL can_more;

@property (nonatomic, copy) NSArray<MAGBookModel *> *list;

@end

NS_ASSUME_NONNULL_END

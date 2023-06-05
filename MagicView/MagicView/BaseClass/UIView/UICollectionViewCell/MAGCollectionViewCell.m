//
//  MAGCollectionViewCell.m
//  MagicView
//
//  Created by LL on 2021/10/21.
//

#import "MAGCollectionViewCell.h"

@implementation MAGCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self defaultInitialize];
        [self initialize];
        [self createSubviews];
    }
    return self;
}

- (void)defaultInitialize {
    self.backgroundColor = mClearColor;
    self.contentView.backgroundColor = mClearColor;
}

- (void)initialize {}

- (void)createSubviews {}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    !self.m_frameBlock ?: self.m_frameBlock(self);
}

@end

//
//  MagicTableSectionView.m
//  MagicView
//
//  Created by LL on 2021/7/6.
//

#import "MAGTableSectionView.h"

@implementation MAGTableSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self defaultInitialize];
        [self initialize];
        [self createSubviews];
    }
    return self;
}

- (void)defaultInitialize {
    [self setBackgroundView:[MAGUIFactory view]];
    self.contentView.backgroundColor = mClearColor;
}

- (void)initialize {}

- (void)createSubviews {}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    !self.m_frameBlock ?: self.m_frameBlock(self);
}

@end

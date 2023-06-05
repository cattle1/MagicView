//
//  MAGRefreshSafeHeader.m
//  MagicView
//
//  Created by LL on 2021/9/22.
//

#import "MAGRefreshSafeHeader.h"

#import "MAGImport.h"

@interface MAGRefreshSafeHeader ()

@property (nonatomic, assign) CGFloat oldHeight;

@end

@implementation MAGRefreshSafeHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.oldHeight = 0.0;
    }
    return self;
}

- (void)placeSubviews {
    [super placeSubviews];
    
    if (self.stateLabel.hidden) return;
    
    self.mj_h = self.oldHeight + mSafeAreaInsertTop;
    
    self.stateLabel.frame = CGRectMake(self.stateLabel.left, mSafeAreaInsertTop, self.stateLabel.width, self.oldHeight);
    self.loadingView.centerY = self.stateLabel.centerY;
    self.arrowView.centerY = self.stateLabel.centerY;
}

- (CGFloat)oldHeight {
    if (_oldHeight == 0.0) {
        _oldHeight = self.mj_h;
    }
    return _oldHeight;
}

@end

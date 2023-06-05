//
//  CALayer+Magic.m
//  MagicView
//
//  Created by LL on 2021/9/19.
//

#import "CALayer+Magic.h"

@implementation CALayer (Magic)

- (void)setM_loadingHidden:(BOOL)loadingHidden {
    [self setAssociateWeakValue:@(loadingHidden) withKey:@selector(m_loadingHidden)];
}

- (BOOL)m_loadingHidden {
    return [[self getAssociatedValueForKey:@selector(m_loadingHidden)] boolValue];
}

- (void)setM_loadingContents:(id)loadingContents {
    [self setAssociateValue:loadingContents withKey:@selector(m_loadingContents)];
}

- (id)m_loadingContents {
    return [self getAssociatedValueForKey:@selector(m_loadingContents)];
}

@end

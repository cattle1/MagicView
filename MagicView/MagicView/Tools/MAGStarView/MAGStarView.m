//
//  StarView.m
//  MiFengBangBangProject
//
//  Created by 朱公园 on 2018/1/4.
//  Copyright © 2018年 yixiuge. All rights reserved.
//

#import "MAGStarView.h"

#import "MAGResourceLinkManager.h"

#import "MAGImport.h"

@interface MAGStarView()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView * frontView;
@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, assign) CGFloat fullScore; //评分的满分值，默认为5
@property (nonatomic, assign) CGFloat actualScore; //评分的实际分数，默认为0
@property(nonatomic,assign)CGFloat starsTotalWidth; //星星占据的总宽度和高度
@end
@implementation MAGStarView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.starScore =1;//默认一个星星代表1分
        self.numberOfStars = 5; //默认最高星星数量5个
        self.actualScore = 0;//默认最低分0分
        self.currentScore = 0;
        self.starSpace = 0;
        self.starSize = 12;
    }
    return self;
}

- (void)start{
    [self removeAllSubviews];
    
    self.actualScore = self.currentScore;
    self.fullScore = self.starScore*self.numberOfStars;
    self.starsTotalWidth =self.starSize*_numberOfStars+ (self.numberOfStars-1)*self.starSpace;
    self.backgroundView = [self createStarViewWithImageColor:mColorRGB(198, 198, 198)];
    self.frontView = [self createStarViewWithImageColor:mColorRGB(255, 138, 39)];
    [self addSubview:self.backgroundView];
    [self addSubview:self.frontView];
    self.width =self.starsTotalWidth;
    self.height =self.starSize;
    [self layoutView];
}
- (void)setCurrentScore:(CGFloat)currentScore{
    _currentScore = currentScore;
    CGFloat scorePercent = [self tranScoreToLength:_currentScore];
    self.frontView.width =self.starsTotalWidth * scorePercent;
}

- (void)setModifyStarLevel:(BOOL)modifyStarLevel{
    _modifyStarLevel = modifyStarLevel;
    if (modifyStarLevel) {
        UIPanGestureRecognizer * swipe = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:swipe];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tap];
    }
}

- (void)layoutView{
    
    CGFloat scorePercent = [self tranScoreToLength:self.actualScore];
    self.frontView.width =self.starsTotalWidth * scorePercent;

}

//将分数，比如4.7转化成比例
- (CGFloat)tranScoreToLength:(CGFloat)score{
    score = score/self.starScore;
    CGFloat width= (self.starSize + self.starSpace)* (int)score + (score-(int)score)*self.starSize;
    return width/self.starsTotalWidth;
}

//将x滑动距离变化成分数
- (CGFloat)ratitoTranScore:(CGFloat)x{
    if (x>= self.starsTotalWidth) {
        return self.numberOfStars*self.starScore;
    }else{
        int count = x/(self.starSpace+self.starSize);
        CGFloat scoreRiht =(x-count*(self.starSpace+self.starSize))-self.starSize;
        if (scoreRiht>=0) {
            return ((count+1)*self.starScore);
        }else{
            return (count*self.starScore+(x-count*(self.starSpace+self.starSize))/self.starSize*self.starScore);
        }
    }
}

- (void)tapClick:(UIGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    CGFloat offset = point.x;
    if (offset>=self.starsTotalWidth) {
        offset = self.starsTotalWidth;
    }else if (offset<=0){
        offset =0;
    }
    
    
    if (self.isOnlyHalfStarOrAllStar) {
        self.actualScore = [self changeToCompleteStar:offset];
    }else{
        self.actualScore = [self ratitoTranScore:offset];
    }
    [self layoutView];
    if (self.handleStarChangeBlock) {
            NSString * actualStr = [NSString stringWithFormat:@"%.1f",self.actualScore];
        if (self.actualScore>self.numberOfStars*self.starScore) {
            actualStr = [NSString stringWithFormat:@"%.1f",(self.numberOfStars*self.starScore)];
        }
        
        self.handleStarChangeBlock(actualStr);
    }
}

// 创建星星View
- (UIView *)createStarViewWithImageColor:(UIColor *)color {
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.starsTotalWidth, self.starSize)];
    view.backgroundColor = [UIColor clearColor];
    view.clipsToBounds = YES;
    for (NSInteger i = 0; i < self.numberOfStars; i++) {
        UIImageView * imageView = [[UIImageView alloc] init];
        if (@available(iOS 13.0, *)) {
            imageView.image = [mStarImage imageWithTintColor:color renderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        imageView.frame = CGRectMake(i*(self.starSize+self.starSpace), 0, self.starSize, self.starSize);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    
    return view;
}

//将点击x的偏移量转化成半颗星或者整颗星的分数
- (CGFloat)changeToCompleteStar:(CGFloat)x {

    for (int i = 0; i<2*self.numberOfStars; i++) {
        if (x>i*(self.starSize+self.starSpace)&& x<=(self.starSize/2+i*(self.starSize+self.starSpace))) {
            return (self.starScore/2+self.starScore*i);
        }
        if (x>(self.starSize/2+i*(self.starSize+self.starSpace))&& x<= ((i+1)*self.starSize+ i*self.starSpace)) {
            return self.starScore*(i+1);
        }
    }
    return self.actualScore;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


@end

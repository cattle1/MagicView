//
//  MAGBUAView.m
//  MagicView
//
//  Created by LL on 2021/10/25.
//

#import "MAGBUAView.h"

#if __has_include("BUAdSDK/BUAdSDK.h")

#import "BUAdSDK/BUAdSDK.h"

@interface MAGBUAView ()<BUNativeExpressBannerViewDelegate>

@property (nonatomic, copy) NSString *adKey;

@property (nonatomic, weak) BUNativeExpressBannerView *bannerView;

@end

@implementation MAGBUAView

- (void)createSubviews {
    [super createSubviews];
    
    UILabel *tipsLabel = [MAGUIFactory labelWithBackgroundColor:mColorRGB(189, 189, 189) font:mFont13 textColor:UIColor.whiteColor];
    tipsLabel.text = @"广告";
    tipsLabel.layer.cornerRadius = 4.5;
    tipsLabel.layer.masksToBounds = YES;
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipsLabel];
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self).offset(-mMoreHalfMargin);
        make.width.mas_equalTo(tipsLabel.m_textWidth + mMoreHalfMargin);
        make.height.mas_equalTo(tipsLabel.m_textHeight + mHalfMargin);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self mp_createBannerAD];
}

- (void)netRequest {
    [super netRequest];
    
    // 获取小说阅读器底部Banner广告的信息
    NSDictionary *param = @{
        @"position" : @"12",
        @"type" : @"1"
    };
    
    mWeakobj(self)
    [MAGNetworkRequestManager POST:mADInfoLink parameters:param modelClass:nil success:^(BOOL isSuccess, id  _Nullable t_model, BOOL isCache, MAGNetworkRequestModel * _Nonnull requestModel) {
        if (isSuccess) {
            NSString *adKey = [NSString stringWithFormat:@"%@", requestModel.data[@"ad_key"]];
            weak_self.adKey = adKey;
            [weak_self mp_createBannerAD];
        } else {
            [mMainWindow m_showErrorHUDFromText:requestModel.msg ?: @"加载失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [mMainWindow m_showErrorHUDFromError:error];
    }];
}


#pragma mark - Private
- (void)mp_createBannerAD {
    if (CGRectEqualToRect(self.bounds, CGRectZero)) return;
    if (mObjectIsEmpty(self.adKey)) return;
    
    if (self.bannerView == nil) {
        BUNativeExpressBannerView *bannerView = [[BUNativeExpressBannerView alloc] initWithSlotID:self.adKey rootViewController:mCurrentViewController adSize:self.size interval:30.0];
        self.bannerView = bannerView;
        bannerView.frame = self.bounds;
        bannerView.delegate = self;
        [self addSubview:bannerView];
        [self.bannerView loadAdData];
    }
}


#pragma mark - BUNativeExpressBannerViewDelegate
- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError *_Nullable)error {
    [mMainWindow m_showErrorHUDFromText:error.localizedDescription ?: @"加载失败"];
}

- (void)nativeExpressBannerAdViewRenderFail:(BUNativeExpressBannerView *)bannerAdView error:(NSError * __nullable)error {
    [mMainWindow m_showErrorHUDFromText:error.localizedDescription ?: @"加载失败"];
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView dislikeWithReason:(NSArray<BUDislikeWords *> *_Nullable)filterwords {
    [mMainWindow m_showSuccessHUDFromText:@"我们会尽量减少此类广告推送"];
    [bannerAdView loadAdData];
}

@end

#else

@implementation MAGBUAView

@end

#endif

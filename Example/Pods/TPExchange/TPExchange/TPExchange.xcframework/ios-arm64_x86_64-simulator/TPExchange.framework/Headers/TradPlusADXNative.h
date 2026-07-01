//
//  TradPlusADXNative.h
//  fluteSDKSample
//
//  Created by xuejun on 2021/10/26.
//  Copyright © 2021 TradPlus. All rights reserved.
//

#import <TPExchange/TradPlusADXBase.h>
#import <TPExchange/TPADXNativeData.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TPADXNativeDelegate;

@interface TradPlusADXNative : TradPlusADXBase

- (BOOL)isReady;

- (void)registerContainer:(UIView *)containerView
       withClickableViews:(NSArray<UIView *> *_Nullable)clickableViews;

- (void)loadWithPayload:(NSDictionary *)payload finishBiddingDate:(NSDate *)finishBiddingDate;

- (void)registerTemplateView;

@property (nonatomic,assign) BOOL isMute;
@property (nonatomic,weak) id <TPADXNativeDelegate> delegate;
@property (nonatomic,weak)UIViewController *rootViewController;

@property (nonatomic,readonly)NSDictionary *bidcn;
@property (nonatomic,assign)BOOL is_template_rendering;
@end

@protocol TPADXNativeDelegate <NSObject>

- (void)ADXLoadFinish:(TPADXNativeData *)nativeData mediaView:(UIView *_Nullable)mediaView;
- (void)ADXTemplateLoadFinish:(UIView *)templateView;
- (void)ADXLoadFailWithError:(NSError *)error;
- (void)ADXImpression;
- (void)ADXShowFailWithError:(NSError *)error;
- (void)ADXClicked;
- (void)ADXClose;
@end

NS_ASSUME_NONNULL_END

//
//  TradPlusADXAdapter.h
//  fluteSDKSample
//
//  Created by xuejun on 2021/10/15.
//  Copyright © 2021 TradPlus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TradPlusAds/TradPlusAds.h>
#import <TPExchange/TradPlusADXBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface TradPlusADXAdapter : NSObject<TradPlusAdapterProtocol>

+ (TradPlusADXAdapter *)sharedInstance;

- (void)addADXBase:(TradPlusADXBase *)adxBase;
- (void)releaseADXBase:(TradPlusADXBase *)adxBase;

///清理所有本地缓存
- (void)clearCache;
@end

NS_ASSUME_NONNULL_END

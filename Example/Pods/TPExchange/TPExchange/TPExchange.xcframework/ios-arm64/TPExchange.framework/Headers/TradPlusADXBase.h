//
//  TradPlusADXBase.h
//  fluteSDKSample
//
//  Created by xuejun on 2021/10/19.
//  Copyright © 2021 TradPlus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TradPlusADXBase : NSObject

- (void)clear;

@property (nonatomic,copy)NSString *ecpm;
@property (nonatomic,copy)NSString *placementId;
@property (nonatomic,assign)BOOL parseCNData;
@property (nonatomic,assign)CGFloat customWindowLevel;
@end

NS_ASSUME_NONNULL_END

//
//  TPADXResourceData.h
//  fluteSDKSample
//
//  Created by xuejun on 2021/10/15.
//  Copyright © 2021 TradPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TPADXResourceData : NSObject

@property (nonatomic,readonly)BOOL isVideoResource;
@property (nonatomic,assign)NSTimeInterval videoDuration;
@property (nonatomic,readonly) NSString *adm;
@end

NS_ASSUME_NONNULL_END

//
//  TPADXAdChoiceView.h
//  TradPlusAds
//
//  Created by xuejun on 2023/8/15.
//  Copyright © 2023 TradPlus. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TPADXAdChoiceView : UIButton

- (void)setup;

@property (nonatomic,assign)BOOL hasERIDInfo;
@property (nonatomic,copy) void (^showERIDAct)(void);
@end

NS_ASSUME_NONNULL_END

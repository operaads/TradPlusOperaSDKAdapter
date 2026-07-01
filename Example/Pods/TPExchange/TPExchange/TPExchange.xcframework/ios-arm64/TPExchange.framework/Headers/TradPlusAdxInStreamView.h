//
//  TradPlusAdxInStreamView.h
//  TradPlusAds
//
//  Created by xuejun on 2023/8/16.
//  Copyright © 2023 TradPlus. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TradPlusAdxInStreamView : UIView

@property (nonatomic,weak)IBOutlet UILabel *ctaLable;
@property (nonatomic,weak)IBOutlet UILabel *timeLabel;
@property (nonatomic,weak)IBOutlet UILabel *skipLabel;

- (void)showERIDInfo;
@end

NS_ASSUME_NONNULL_END

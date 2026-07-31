#import <Foundation/Foundation.h>

#if DEBUG
#define OpAdxTradPlusLog(...) NSLog(__VA_ARGS__)
#else
#define OpAdxTradPlusLog(...) ((void)0)
#endif

static NSString * const kOpAdxTradPlusAppIdKey = @"appId";
static NSString * const kOpAdxTradPlusPlacementIdKey = @"placementId";
static NSString * const kOpAdxTradPlusBundleIdKey = @"bundleId";
static NSString * const kOpAdxTradPlusVideoMutedKey = @"videoMuted";
static NSString * const kOpAdxTradPlusMuteKey = @"mute";


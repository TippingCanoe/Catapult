//
//  CTumblrService.m
//  Catapult
//
//  Created by Jeff on 2/10/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CTumblrTarget.h"
#import <TMTumblrAppClient.h>

@implementation CTumblrTarget
+ (CatapultTargetType)targetType{
    return CatapultTargetTypeURL | CatapultTargetTypeText;
}

+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete{
    [TMTumblrAppClient createLinkPost:payload.text URLString:payload.url.absoluteString description:payload.text tags:@[]];
}

+ (NSString *)targetName{
    return NSLocalizedString(@"Tumblr", nil);
}

+ (NSURL *)appURL{
    return [NSURL URLWithString:@"tumblr://"];
}

+ (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source{
    
}
@end

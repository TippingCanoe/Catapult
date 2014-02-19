
//
//  CSafariTarget.m
//  Catapult
//
//  Created by Jeff on 2/19/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CSafariTarget.h"

@implementation CSafariTarget

+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete{
    
    [[UIApplication sharedApplication] openURL:payload.url];
    if (complete) {
        complete(YES);
    }
}

+ (NSString *)targetName{
    return NSLocalizedString(@"Safari", nil);
}

+ (BOOL)isAvailable{
    return YES;
}

+ (BOOL)canHandlePayload:(CatapultPayload *)payload{
    return payload.targetType & CatapultTargetTypeURL;
}

+ (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source{
    
}
@end

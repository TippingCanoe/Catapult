
//
//  CSafariTarget.m
//  Catapult
//
//  Created by Jeff on 2/19/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CSafariTarget.h"

@implementation CSafariTarget
+ (CatapultTargetType)targetType{
    return CatapultTargetTypeURL;
}

+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete{
    
    [[UIApplication sharedApplication] openURL:payload.url];
    if (complete) {
        complete(YES);
    }
}

+ (NSString *)targetName{
    return NSLocalizedString(@"Safari", nil);
}

+ (BOOL)canHandle{
    return YES;
}

+ (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source{
    
}
@end

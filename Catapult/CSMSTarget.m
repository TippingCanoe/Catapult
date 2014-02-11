//
//  CSMSService.m
//  Catapult
//
//  Created by Jeff on 2/10/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CSMSTarget.h"

@implementation CSMSTarget
+ (CatapultTargetType)targetType{
    return CatapultTargetTypeURL | CatapultTargetTypeText;
}

+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete{
    if (complete) {
        complete(NO);
    }
}

+ (NSString *)targetName{
    return NSLocalizedString(@"Pinterest", nil);
}

+ (NSURL *)appURL{
    return nil;
}

+ (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source{
    
}
@end

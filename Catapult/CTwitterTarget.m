//
//  CTwitterService.m
//  Catapult
//
//  Created by Jeff on 2/10/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CTwitterTarget.h"

@implementation CTwitterTarget
+ (CatapultTargetType)targetType{
    return CatapultTargetTypeText & CatapultTargetTypeURL;
}

+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options andComplete:(void(^)(BOOL success))complete{
    if (complete) {
        complete(NO);
    }
}

+ (NSString *)targetName{
    return NSLocalizedString(@"Twitter", nil);
}

+ (NSURL *)appURL{
    return nil;
}
@end

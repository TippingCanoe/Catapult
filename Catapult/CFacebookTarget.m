//
//  CFacebookService.m
//  Catapult
//
//  Created by Jeff on 2/10/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CFacebookTarget.h"

@implementation CFacebookTarget
+ (CatapultTargetType)targetType{
    return CatapultTargetTypeText & CatapultTargetTypeURL;
}

+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options andComplete:(void(^)(BOOL success))complete{
    if (complete) {
        complete(NO);
    }
}

+ (NSString *)targetName{
    return NSLocalizedString(@"Facebook", nil);
}

+ (NSURL *)appURL{
    return nil;
}
@end

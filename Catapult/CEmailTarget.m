//
//  CEmailTarget.m
//  Catapult
//
//  Created by Jeff on 2/11/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CEmailTarget.h"

@implementation CEmailTarget
+ (CatapultTargetType)targetType{
    return CatapultTargetTypeURL | CatapultTargetTypeText;
}

+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options andComplete:(void(^)(BOOL success))complete{
    if (complete) {
        complete(NO);
    }
}

+ (NSString *)targetName{
    return NSLocalizedString(@"Email", nil);
}

+ (NSURL *)appURL{
    return nil;
}

+ (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source{
    
}
@end

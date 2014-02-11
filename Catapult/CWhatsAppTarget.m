//
//  CWhatsAppService.m
//  Catapult
//
//  Created by Jeff on 2/10/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CWhatsAppTarget.h"

@implementation CWhatsAppTarget
+ (CatapultTargetType)targetType{
    return CatapultTargetTypeText | CatapultTargetTypeURL;
}

+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete{
    if (complete) {
        complete(NO);
    }
}

+ (NSString *)targetName{
    return NSLocalizedString(@"WhatsApp", nil);
}

+ (NSURL *)appURL{
    return [NSURL URLWithString:@"whatsapp://"];
}

+ (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source{
    
}
@end

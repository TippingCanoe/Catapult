//
//  CWhatsAppService.m
//  Catapult
//
//  Created by Jeff on 2/10/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CWhatsAppTarget.h"
#import <NSString+UrlEncode.h>

@implementation CWhatsAppTarget
+ (CatapultTargetType)targetType{
    return CatapultTargetTypeText;
}

+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete{
    NSString *message = payload.text;
    if (payload.url) {
        message = [message stringByAppendingFormat:@" %@",payload.url.absoluteString];
    }
    message = [message urlEncode];
    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@",message]];
    [[UIApplication sharedApplication] openURL: whatsappURL];
    if (complete) {
        complete(YES);
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

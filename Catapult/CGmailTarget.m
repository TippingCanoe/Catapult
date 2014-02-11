//
//  CGmailTarget.m
//  Catapult
//
//  Created by Jeff on 2/11/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CGmailTarget.h"
#import <NSString+UrlEncode.h>

@implementation CGmailTarget
+ (CatapultTargetType)targetType{
    return CatapultTargetTypeText;
}

+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete{
    NSString *message = payload.text;
    if (payload.url) {
        message = [message stringByAppendingFormat:@" %@",payload.url.absoluteString];
    }
    message = [message urlEncode];
    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"googlegmail://co?subject=%@&body=%@",payload.text,message]];
    [[UIApplication sharedApplication] openURL: whatsappURL];
    if (complete) {
        complete(YES);
    }
}

+ (NSString *)targetName{
    return NSLocalizedString(@"Gmail", nil);
}

+ (BOOL)canHandle{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlegmail://"]];
}

+ (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source{
    
}
@end

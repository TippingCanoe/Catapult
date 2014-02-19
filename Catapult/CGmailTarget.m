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

static NSURL *_successURL;
static NSURL *_cancelURL;
static CGmailTarget *_shared;

+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete{
    
    _shared = [[CGmailTarget alloc] init];
    _shared.complete = complete;
    
    NSString *message = payload.text;
    if (payload.url) {
        message = [message stringByAppendingFormat:@" %@",payload.url.absoluteString];
    }
    NSString *urlString = [NSString stringWithFormat:@"googlegmail-x-callback://x-callback-url/co?subject=%@&body=%@",[payload.text urlEncode],[message urlEncode]];
    
    if ([options objectForKey:kCatapultRecipientEmail]) {
        NSString *email = [options objectForKey:kCatapultRecipientEmail];
        urlString = [urlString stringByAppendingFormat:@"&to=%@",[email urlEncode]];
    }
    if (_successURL) {
        urlString = [urlString stringByAppendingFormat:@"&x-success=%@",_successURL.absoluteString.urlEncode];
    }
    
    if (_cancelURL) {
        urlString = [urlString stringByAppendingFormat:@"&x-cancel=%@",_cancelURL.absoluteString.urlEncode];
        urlString = [urlString stringByAppendingFormat:@"&x-error=%@",_cancelURL.absoluteString.urlEncode];
    }
    
    urlString = [urlString stringByAppendingFormat:@"&x-source=%@",NSBundle.mainBundle.infoDictionary[@"CFBundleDisplayName"]];
    
    NSURL *gmailURL = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:gmailURL];
    if (complete) {
        complete(YES);
    }
}

+ (NSString *)targetName{
    return NSLocalizedString(@"Gmail", nil);
}

+ (BOOL)isAvailable{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlegmail://"]];
}

+ (BOOL)canHandlePayload:(CatapultPayload *)payload{
    return payload.targetType & CatapultTargetTypeText;
}

+ (void)setSuccessURL:(NSURL *)success{
    _successURL = success;
}
+ (void)setCancelURL:(NSURL *)cancel{
    _cancelURL = cancel;
}

+ (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source{
    if (_shared && _shared.complete) {
        if ([url isEqual:_successURL]) {
            _shared.complete(YES);
        }else if([url isEqual:_cancelURL]){
            _shared.complete(NO);
        }
    }
    _shared = nil;
}
@end

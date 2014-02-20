//
//  CChromeTarget.m
//  Catapult
//
//  Created by Jeff on 2/19/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CChromeTarget.h"
#import <NSString+UrlEncode.h>

@implementation CChromeTarget
static NSURL *_successURL;
static NSURL *_cancelURL;
static CChromeTarget *_shared;

+ (void)launchPayload:(CatapultPayload *)payload fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete{
    
    _shared = [[CChromeTarget alloc] init];
    _shared.complete = complete;
    
    NSString *message = payload.text;
    if (payload.url) {
        message = [message stringByAppendingFormat:@" %@",payload.url.absoluteString];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"googlechrome-x-callback://x-callback-url/open?url=%@&create-new-tab=yes",[payload.url.absoluteString urlEncode]];
    
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
    return NSLocalizedString(@"Chrome", nil);
}

+ (BOOL)isAvailable{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlechrome-x-callback://"]];
}

+ (BOOL)canHandlePayload:(CatapultPayload *)payload{
    return payload.targetType & CatapultTargetTypeURL;
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

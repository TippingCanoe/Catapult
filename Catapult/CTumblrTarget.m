//
//  CTumblrService.m
//  Catapult
//
//  Created by Jeff on 2/10/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CTumblrTarget.h"
#import <TMTumblrAppClient.h>

@implementation CTumblrTarget

static NSURL *_successURL;
static NSURL *_cancelURL;
static CTumblrTarget *_shared;

+ (CatapultTargetType)targetType{
    return CatapultTargetTypeText;
}

+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete{
    
    _shared = [[CTumblrTarget alloc] init];
    _shared.complete = complete;
    
    if (payload.url) {
        [TMTumblrAppClient createLinkPost:payload.text URLString:payload.url.absoluteString description:payload.text tags:@[] success:_successURL cancel:_cancelURL];
    }else{
        [TMTumblrAppClient createTextPost:payload.text body:payload.text tags:@[] success:_successURL cancel:_cancelURL];
    }
}

+ (NSString *)targetName{
    return NSLocalizedString(@"Tumblr", nil);
}

+ (NSURL *)appURL{
    return [NSURL URLWithString:@"tumblr://"];
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

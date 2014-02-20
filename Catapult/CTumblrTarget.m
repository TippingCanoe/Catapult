//
//  CTumblrService.m
//  Catapult
//
//  Created by Jeff on 2/10/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CTumblrTarget.h"
#import <TMTumblrAppClient.h>
#import "NSObject+URLScheme.h"

@implementation CTumblrTarget

static NSURL *_successURL;
static NSURL *_cancelURL;
static CTumblrTarget *_shared;

+ (void)launchPayload:(CatapultPayload *)payload fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete{
    
    NSString *tumblrBlog = payload.additionalOptions[kCatapultTumblrBlogName];
    if (tumblrBlog) {
        [TMTumblrAppClient viewBlog:tumblrBlog];
    }else{
        _shared = [[CTumblrTarget alloc] init];
        _shared.complete = complete;
        
        if (payload.url) {
            [TMTumblrAppClient createLinkPost:payload.text URLString:payload.url.absoluteString description:payload.text tags:@[] success:_successURL cancel:_cancelURL];
        }else{
            [TMTumblrAppClient createTextPost:payload.text body:payload.text tags:@[] success:_successURL cancel:_cancelURL];
        }
    }
}

+ (NSString *)targetName{
    return NSLocalizedString(@"Tumblr", nil);
}

+ (BOOL)isAvailable{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tumblr://"]];
}

+ (BOOL)canHandlePayload:(CatapultPayload *)payload{
    if (payload.additionalOptions[kCatapultTumblrBlogName]) {
        return YES;
    }
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

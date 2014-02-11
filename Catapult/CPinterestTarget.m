//
//  CPinterstService.m
//  Catapult
//
//  Created by Jeff on 2/10/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CPinterestTarget.h"
#import <Pinterest.h>

@implementation CPinterestTarget

static NSString *_pinterestId;
static CPinterestTarget *_shared;

+ (CatapultTargetType)targetType{
    return CatapultTargetTypeURL | CatapultTargetTypeText | CatapultTargetTypeImageURL;
}

+ (void)setPinterestID:(NSString *)string{
    _pinterestId = string;
}

+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete{
    if (_pinterestId) {
        
        _shared = [[CPinterestTarget alloc] init];
        _shared.complete = complete;
        
        Pinterest *pinterest = [[Pinterest alloc] initWithClientId:_pinterestId];
        [pinterest createPinWithImageURL:payload.imageURL
                               sourceURL:payload.url
                             description:payload.text];
    }else{
        if (complete) {
            complete(NO);
        }
    }
}

+ (NSString *)targetName{
    return NSLocalizedString(@"Pinterest", nil);
}

+ (BOOL)canHandle{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"pinterest://"]];
}

+ (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

+ (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source{
    if ([source isEqualToString:@"pinterest"] && _shared && _shared.complete) {
        NSDictionary *params = [self parseURLParams:url.query];
        if ([[params objectForKey:@"pin_success"] isEqualToString:@"0"]) {
            _shared.complete(NO);
        }else{
            _shared.complete(YES);
        }
    }
}
@end

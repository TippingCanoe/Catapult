//
//  CPinterstService.m
//  Catapult
//
//  Created by Jeff on 2/10/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CPinterstTarget.h"
#import <Pinterest.h>

@implementation CPinterstTarget

static NSString *_pinterestId;

+ (CatapultTargetType)targetType{
    return CatapultTargetTypeURL | CatapultTargetTypeText;
}

+ (void)setPinterestID:(NSString *)string{
    _pinterestId = string;
}

+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete{
    if (_pinterestId) {
        Pinterest *pinterest = [[Pinterest alloc] initWithClientId:_pinterestId];
        [pinterest createPinWithImageURL:nil
                               sourceURL:payload.url
                             description:payload.text];
        if (complete) {
            complete(YES);
        }
    }else{
        if (complete) {
            complete(NO);
        }
    }
}

+ (NSString *)targetName{
    return NSLocalizedString(@"Pinterest", nil);
}

+ (NSURL *)appURL{
    return [NSURL URLWithString:@"pinterest://"];
}

+ (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source{
    
}
@end

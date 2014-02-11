//
//  CTwitterService.m
//  Catapult
//
//  Created by Jeff on 2/10/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CTwitterTarget.h"
#import <Social/Social.h>

@implementation CTwitterTarget
+ (CatapultTargetType)targetType{
    return CatapultTargetTypeText | CatapultTargetTypeURL | CatapultTargetTypeImage;
}

+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete{
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:
                                           SLServiceTypeTwitter];
    
    tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
                //  This means the user cancelled without sending the Tweet
            case SLComposeViewControllerResultCancelled:
                if (complete) {
                    complete(YES);
                }
                break;
                //  This means the user hit 'Send'
            case SLComposeViewControllerResultDone:
                if (complete) {
                    complete(NO);
                }
                break;
        }
    };
    
    [tweetSheet setInitialText:payload.text];
    [tweetSheet addImage:payload.image];
    [tweetSheet addURL:payload.url];
    
    [vc presentViewController:tweetSheet animated:NO completion:nil];
}

+ (NSString *)targetName{
    return NSLocalizedString(@"Twitter", nil);
}

+ (NSURL *)appURL{
    return nil;
}

+ (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source{
    
}
@end

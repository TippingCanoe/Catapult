//
//  CSMSService.m
//  Catapult
//
//  Created by Jeff on 2/10/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CSMSTarget.h"

@implementation CSMSTarget

static CSMSTarget *_shared;

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    if (_complete) {
        if (result == MessageComposeResultSent) {
            _complete(YES);
        }else{
            _complete(NO);
        }
    }
    controller.delegate = nil;
}

+ (CatapultTargetType)targetType{
    return CatapultTargetTypeText;
}

+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete{
    
    _shared = [[CSMSTarget alloc] init];
    _shared.complete = complete;
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    NSString *body = payload.text;
    if (payload.url) {
        body = [body stringByAppendingFormat:@" %@",payload.url.absoluteString];
    }
    controller.body = body;
    controller.messageComposeDelegate = _shared;
    [vc presentViewController:controller animated:YES completion:nil];
}

+ (NSString *)targetName{
    return NSLocalizedString(@"SMS", nil);
}

+ (BOOL)canHandle{
    return [MFMessageComposeViewController canSendText];
}

+ (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source{
    
}
@end

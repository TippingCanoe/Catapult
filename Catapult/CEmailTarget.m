//
//  CEmailTarget.m
//  Catapult
//
//  Created by Jeff on 2/11/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CEmailTarget.h"
#import <MessageUI/MFMailComposeViewController.h>

@implementation CEmailTarget

static CEmailTarget *_shared;

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (_complete) {
        if (result == MFMailComposeResultSent || result == MFMailComposeResultSaved) {
            _complete(YES);
        }else{
            _complete(NO);
        }
    }
    controller.delegate = nil;
    [[controller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

+ (void)launchPayload:(CatapultPayload *)payload fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete{
    
    _shared = [[CEmailTarget alloc] init];
    _shared.complete = complete;
    
    NSString *body = payload.text;
    if (payload.url) {
        body = [body stringByAppendingFormat:@" %@",payload.url.absoluteString];
    }
    
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    [[mailer navigationBar] setTintColor:[UIColor blackColor]];
    mailer.mailComposeDelegate = _shared;
    mailer.modalPresentationStyle = UIModalPresentationPageSheet;
    [mailer setSubject:payload.text];
    
    if ([payload.additionalOptions objectForKey:kCatapultRecipientEmail]) {
        NSString *email = [payload.additionalOptions objectForKey:kCatapultRecipientEmail];
        [mailer setToRecipients:@[email]];
    }
    
    [mailer setMessageBody:body isHTML:NO];
    [vc presentViewController:mailer animated:YES completion:nil];
}

+ (NSString *)targetName{
    return NSLocalizedString(@"Email", nil);
}

+ (BOOL)isAvailable{
    return [MFMailComposeViewController canSendMail];
}

+ (BOOL)canHandlePayload:(CatapultPayload *)payload{
    return payload.targetType & CatapultTargetTypeText && [MFMailComposeViewController canSendMail];
}

+ (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source{
    
}
@end

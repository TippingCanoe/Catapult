//
//  CEmailTarget.m
//  Catapult
//
//  Created by Jeff on 2/11/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CEmailTarget.h"

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
}

+ (CatapultTargetType)targetType{
    return CatapultTargetTypeText;
}

+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete{
    
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
    
    [mailer setMessageBody:body isHTML:NO];
    [vc presentViewController:mailer animated:YES completion:nil];
}

+ (NSString *)targetName{
    return NSLocalizedString(@"SMS", nil);
}

+ (BOOL)canHandle{
    return [MFMailComposeViewController canSendMail];
}

+ (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source{
    
}
@end

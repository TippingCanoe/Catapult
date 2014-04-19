//
//  CFacebookService.m
//  Catapult
//
//  Created by Jeff on 2/10/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "CFacebookTarget.h"
#import <FBAppCall.h>
#import <Facebook.h>
#import "NSObject+URLScheme.h"

@implementation CFacebookTarget

+ (void)launchPayload:(CatapultPayload *)payload fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete{
    
    NSURL *facebookURL = [payload.additionalOptions[kCatapultAlternativeURL] urlMatchingScheme:@"fb"];
    if (facebookURL == nil) {
        facebookURL = [payload.url urlMatchingScheme:@"fb"];
    }
    if (facebookURL) {
        [[UIApplication sharedApplication] openURL:facebookURL];
    }else{
        FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
        params.link = payload.url;
        params.name = [payload.additionalOptions objectForKey:kCFacebookTargetTitle];
        params.caption = [payload.additionalOptions objectForKey:kCFacebookTargetSubtitle];
        params.picture = payload.imageURL;
        params.description = payload.text;
        
        // If the Facebook app is installed and we can present the share dialog
        if ([FBDialogs canPresentShareDialogWithParams:params]) {
            // Present the share dialog
            [FBDialogs presentShareDialogWithLink:params.link
                                             name:params.name
                                          caption:params.caption
                                      description:params.description
                                          picture:params.picture
                                      clientState:nil
                                          handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                              if (complete) {
                                                  if(error) {
                                                      complete(NO);
                                                  } else {
                                                      if ([[results objectForKey:@"completionGesture"] isEqualToString:@"cancel"]) {
                                                          complete(NO);
                                                      }else{
                                                          complete(YES);
                                                      }
                                                  }
                                              }
                                          }];
        } else {
            // Present the feed dialog
            NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
            if (params.name) {
                [paramDictionary setObject:params.name forKey:@"name"];
            }
            if (params.link) {
                [paramDictionary setObject:params.link.absoluteString forKey:@"link"];
            }
            if (params.caption) {
                [paramDictionary setObject:params.name forKey:@"caption"];
            }
            if (params.description) {
                [paramDictionary setObject:params.description forKey:@"description"];
            }
            if (params.picture) {
                [paramDictionary setObject:params.picture.absoluteString forKey:@"picture"];
            }
            
            // Show the feed dialog
            [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                                   parameters:paramDictionary
                                                      handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                          if (complete) {
                                                              if (error) {
                                                                  complete(NO);
                                                              } else {
                                                                  if (result == FBWebDialogResultDialogNotCompleted) {
                                                                      complete(NO);
                                                                  } else {
                                                                      NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                                      
                                                                      if (![urlParams valueForKey:@"post_id"]) {
                                                                          complete(NO);
                                                                      } else {
                                                                          complete(YES);
                                                                      }
                                                                  }
                                                              }
                                                          }
                                                      }];
        }
    }
    
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

+ (BOOL)canHandlePayload:(CatapultPayload *)payload{
    if ([payload.additionalOptions[kCatapultAlternativeURL] urlMatchingScheme:@"fb"]) {
        return YES;
    }else if([payload.url urlMatchingScheme:@"fb"]){
        return YES;
    }
    return payload.targetType & CatapultTargetTypeText;
}

+ (BOOL)isAvailable{
    return YES;
}

+ (NSString *)targetName{
    return NSLocalizedString(@"Facebook", nil);
}

+ (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source{
    [FBAppCall handleOpenURL:url
           sourceApplication:source
             fallbackHandler:^(FBAppCall *call) {
                 
             }];
}
@end

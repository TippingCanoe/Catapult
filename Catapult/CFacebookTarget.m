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

@implementation CFacebookTarget


+ (CatapultTargetType)targetType{
    return CatapultTargetTypeText | CatapultTargetTypeURL;
}

+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete{
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = payload.url;
    params.name = [options objectForKey:kCFacebookTargetTitle];
    params.caption = [options objectForKey:kCFacebookTargetSubtitle];
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
            [paramDictionary setObject:params.link forKey:@"link"];
        }
        if (params.caption) {
            [paramDictionary setObject:params.name forKey:@"caption"];
        }
        if (params.description) {
            [paramDictionary setObject:params.description forKey:@"description"];
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

+ (NSString *)targetName{
    return NSLocalizedString(@"Facebook", nil);
}

+ (NSURL *)appURL{
    return nil;
}

+ (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source{
    [FBAppCall handleOpenURL:url
           sourceApplication:source
             fallbackHandler:^(FBAppCall *call) {
                 
    }];
}
@end

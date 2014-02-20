//
//  Catapult.m
//  Catapult
//
//  Created by Jeff on 2/10/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "Catapult.h"
#import <OHActionSheet.h>

@implementation CatapultPayload

- (CatapultTargetType)targetType{
    CatapultTargetType type = 0;
    if (self.text) {
        type |= CatapultTargetTypeText;
    }
    if (self.url) {
        type |= CatapultTargetTypeURL;
    }
    if (self.image) {
        type |= CatapultTargetTypeImage;
    }
    if (self.imageURL) {
        type |= CatapultTargetTypeImageURL;
    }
    return type;
}
@end

@implementation Catapult

static Catapult *_shared;

+ (instancetype)shared{
    if (_shared == nil) {
        _shared = [[Catapult alloc] init];
    }
    return _shared;
}

- (id)init{
    self = [super init];
    if (self) {
        targetArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)registerTarget:(Class<CatapultTarget>)target{
    [targetArray addObject:target];
}

- (NSArray *)targetsThatHandlePayload:(CatapultPayload *)payload fromArray:(NSArray *)source{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSObject<CatapultTarget> *target in source) {
        if ([target.class isAvailable] && [target.class canHandlePayload:payload]) {
            [array addObject:target];
        }
    }
    return array;
}

+ (NSArray *)targetNameArrayForTargetArray:(NSArray *)targets{
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for (NSObject<CatapultTarget> *target in targets) {
        [names addObject:[target.class targetName]];
    }
    return names;
}

- (void)takeAimWithPayload:(CatapultPayload*)payload
          fromViewController:(UIViewController *)viewController
                 andComplete:(void(^)(BOOL success, Class<CatapultTarget> selectedtarget))complete{
    
    NSArray *targets = [self targetsThatHandlePayload:payload fromArray:targetArray];
    [self showActionSheetForTargets:targets fromViewController:viewController andPayload:payload andComplete:complete];
}

- (void)takeAimWithPayload:(CatapultPayload*)payload
        fromViewController:(UIViewController *)viewController
        andSpecificTargets:(NSArray *)targets
               andComplete:(void(^)(BOOL success, Class<CatapultTarget> selectedtarget))complete{
    
    targets = [self targetsThatHandlePayload:payload fromArray:targets];
    
    [self showActionSheetForTargets:targets fromViewController:viewController andPayload:payload andComplete:complete];
}



- (void)showActionSheetForTargets:(NSArray *)targets
               fromViewController:(UIViewController *)viewController
                       andPayload:(CatapultPayload *)payload
                      andComplete:(void(^)(BOOL success, Class<CatapultTarget> selectedtarget))complete{
    
    if (targets.count == 1) {
        NSObject<CatapultTarget> *target = [targets objectAtIndex:0];
        lastTarget = target.class;
        [target.class launchPayload:payload fromViewController:viewController andComplete:^(BOOL success){
            if (complete) {
                complete(success,target.class);
            }
        }];
    }else if(targets.count > 1){
        [OHActionSheet showSheetInView:viewController.view
                                 title:[payload.additionalOptions objectForKey:kCatapultTitle]?[payload.additionalOptions objectForKey:kCatapultTitle]:NSLocalizedString(@"Share", nil)
                     cancelButtonTitle:[payload.additionalOptions objectForKey:kCatapultCancel]?[payload.additionalOptions objectForKey:kCatapultCancel]:NSLocalizedString(@"Cancel", nil)
                destructiveButtonTitle:nil
                     otherButtonTitles:[self.class targetNameArrayForTargetArray:targets]
                            completion:^(OHActionSheet *sheet, NSInteger buttonIndex)
         {
             if (buttonIndex == sheet.cancelButtonIndex) {
                 if (complete) {
                     complete(NO,nil);
                 }
             } else if (buttonIndex == sheet.destructiveButtonIndex) {
                 if (complete) {
                     complete(NO,nil);
                 }
             } else {
                 NSObject<CatapultTarget> *target = [targets objectAtIndex:buttonIndex];
                 lastTarget = target.class;
                 [target.class launchPayload:payload fromViewController:viewController andComplete:^(BOOL success){
                     if (complete) {
                         complete(success,target.class);
                     }
                 }];
             }
         }];
    }
}

- (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source{
    if (lastTarget) {
        [lastTarget handleURL:url fromSourceApplication:source];
    }
}
@end


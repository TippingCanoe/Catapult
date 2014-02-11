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

- (BOOL)registerTarget:(Class<CatapultTarget>)target{
    NSObject<CatapultTarget> *targetObject = (NSObject<CatapultTarget>*)target;
    
    BOOL isValid = YES;
    
    if ([targetObject.class appURL]) {
        isValid = [[UIApplication sharedApplication] canOpenURL:[targetObject.class appURL]];
    }
    
    if (isValid) {
        [targetArray addObject:target];
    }
    
    return isValid;
}

- (NSArray *)targetsFortargetType:(CatapultTargetType)targetType{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSObject<CatapultTarget> *target in targetArray) {
        if ((([target.class targetType] ^ targetType) & targetType) || targetType == [target.class targetType]) {
            [array addObject:target];
        }
    }
    return array;
}

+ (NSArray *)targetNameArrayFortargetArray:(NSArray *)targets{
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for (NSObject<CatapultTarget> *target in targets) {
        [names addObject:[target.class targetName]];
    }
    return names;
}

- (void)takeAimAtWithPayload:(CatapultPayload*)payload
          fromViewController:(UIViewController *)viewController
                 withOptions:(NSDictionary *)dictionary
                 andComplete:(void(^)(BOOL success, Class<CatapultTarget> selectedtarget))complete{
    
    NSArray *targets = [self targetsFortargetType:payload.targetType];
    
    [OHActionSheet showSheetInView:viewController.view
                             title:[dictionary objectForKey:kCatapultTitle]?[dictionary objectForKey:kCatapultTitle]:NSLocalizedString(@"Share", nil)
                 cancelButtonTitle:[dictionary objectForKey:kCatapultCancel]?[dictionary objectForKey:kCatapultCancel]:NSLocalizedString(@"Cancel", nil)
            destructiveButtonTitle:nil
                 otherButtonTitles:[self.class targetNameArrayFortargetArray:targets]
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
             [target.class launchPayload:payload withOptions:dictionary fromViewController:viewController andComplete:^(BOOL success){
                 if (complete) {
                     complete(success,target.class);
                 }
             }];
         }
     }];
}

- (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source{
    if (lastTarget) {
        [lastTarget handleURL:url fromSourceApplication:source];
    }
}
@end


//
//  Catapult.h
//  Catapult
//
//  Created by Jeff on 2/10/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kCatapultTitle @"kCatapultTitle"
#define kCatapultCancel @"kCatapultCancel"

#define kCatapultRecipientEmail @"kCatapultRecipientEmail"

typedef NS_OPTIONS(NSUInteger, CatapultTargetType) {
    CatapultTargetTypeText                = 1 << 0,
    CatapultTargetTypeURL                 = 1 << 1,
    CatapultTargetTypeImage               = 1 << 2,
    CatapultTargetTypeImageURL            = 1 << 3,
    CatapultTargetTypeAll                 = CatapultTargetTypeText | CatapultTargetTypeURL | CatapultTargetTypeImage | CatapultTargetTypeImageURL
};


@interface CatapultPayload : NSObject

@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSURL *imageURL;

- (CatapultTargetType)targetType;

@end

@protocol CatapultTarget <NSObject>
+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options fromViewController:(UIViewController *)vc andComplete:(void(^)(BOOL success))complete;
+ (NSString *)targetName;
+ (BOOL)canHandlePayload:(CatapultPayload *)payload;
+ (BOOL)isAvailable;
+ (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source;
@end

@interface Catapult : NSObject{
    NSMutableArray *targetArray;
    
    Class<CatapultTarget> lastTarget;
}

+ (instancetype)shared;

- (void)registerTarget:(Class<CatapultTarget>)target;

- (void)takeAimWithPayload:(CatapultPayload*)payload
          fromViewController:(UIViewController *)viewController
                 withOptions:(NSDictionary *)dictionary
                 andComplete:(void(^)(BOOL success, Class<CatapultTarget> selectedtarget))complete;

- (void)takeAimWithPayload:(CatapultPayload*)payload
        fromViewController:(UIViewController *)viewController
               withOptions:(NSDictionary *)dictionary
        andSpecificTargets:(NSArray *)targets
               andComplete:(void(^)(BOOL success, Class<CatapultTarget> selectedtarget))complete;

- (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source;
@end

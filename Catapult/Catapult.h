//
//  Catapult.h
//  Catapult
//
//  Created by Jeff on 2/10/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, CatapultTargetType) {
    CatapultTargetTypeText                = 1 << 0,
    CatapultTargetTypeURL                 = 1 << 1,
    CatapultTargetTypeImage               = 1 << 2,
    CatapultTargetTypeAll                 = CatapultTargetTypeText | CatapultTargetTypeURL | CatapultTargetTypeImage
};


@interface CatapultPayload : NSObject

@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) UIImage *image;

- (instancetype)initWithText:(NSString *)text;
- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithText:(NSString *)text andURL:(NSURL *)url;
- (instancetype)initWithText:(NSString *)text andImage:(UIImage *)image;
- (instancetype)initWithURL:(NSURL *)url andImage:(UIImage *)image;
- (instancetype)initWithText:(NSString *)text andURL:(NSURL *)url andImage:(UIImage *)image;

- (CatapultTargetType)targetType;

@end

@protocol CatapultTarget <NSObject>
+ (CatapultTargetType)targetType;
+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options andComplete:(void(^)(BOOL success))complete;
+ (NSString *)targetName;
+ (NSURL *)appURL;
+ (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source;
@end

@interface Catapult : NSObject{
    NSMutableArray *texttargets;
    NSMutableArray *urltargets;
    NSMutableArray *imagetargets;
    
    Class<CatapultTarget> lastTarget;
}

+ (instancetype)shared;

- (BOOL)registerTarget:(Class<CatapultTarget>)target;

- (void)takeAimAtWithPayload:(CatapultPayload*)payload
          fromViewController:(UIViewController *)viewController
                 withOptions:(NSDictionary *)dictionary
                 andComplete:(void(^)(BOOL success, Class<CatapultTarget> selectedtarget))complete;

- (void)handleURL:(NSURL *)url fromSourceApplication:(NSString *)source;
@end

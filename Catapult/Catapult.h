//
//  Catapult.h
//  Catapult
//
//  Created by Jeff on 2/10/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, CatapultServiceType) {
    CatapultServiceTypeText                = 0,
    CatapultServiceTypeURL                 = 1 << 0,
    CatapultServiceTypeImage               = 1 << 1,
    CatapultServiceTypeAll                 = CatapultServiceTypeText & CatapultServiceTypeURL & CatapultServiceTypeImage
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

@end

@protocol CatapultService <NSObject>
+ (CatapultServiceType)serviceType;
+ (void)launchPayload:(CatapultPayload *)payload withOptions:(NSDictionary *)options andComplete:(void(^)(BOOL success))complete;
+ (NSString *)serviceName;
+ (NSURL *)appURL;
@end

@interface Catapult : NSObject

+ (instancetype)shared;

- (BOOL)registerService:(Class<CatapultService>)service;

- (void)takeAimAtServiceType:(CatapultServiceType)serviceType
                 withPayload:(CatapultPayload*)payload
          fromViewController:(UIViewController *)viewController
                 withOptions:(NSDictionary *)dictionary
                 andComplete:(void(^)(BOOL success, Class<CatapultService> selectedService))complete;
@end

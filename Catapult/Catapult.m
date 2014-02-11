//
//  Catapult.m
//  Catapult
//
//  Created by Jeff on 2/10/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "Catapult.h"
#import <UIActionSheet+Blocks.h>

@implementation CatapultPayload
- (instancetype)initWithText:(NSString *)text{
    self = [super init];
    if (self) {
        self.text = text;
    }
    return self;
}
- (instancetype)initWithURL:(NSURL *)url{
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}
- (instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    if (self) {
        self.image = image;
    }
    return self;
}
- (instancetype)initWithText:(NSString *)text andURL:(NSURL *)url{
    self = [self initWithText:text];
    if (self) {
        self.url = url;
    }
    return self;
}
- (instancetype)initWithText:(NSString *)text andImage:(UIImage *)image{
    self = [self initWithText:text];
    if (self) {
        self.image = image;
    }
    return self;
}
- (instancetype)initWithURL:(NSURL *)url andImage:(UIImage *)image{
    self = [self initWithURL:url];
    if (self) {
        self.image = image;
    }
    return self;
}
- (instancetype)initWithText:(NSString *)text andURL:(NSURL *)url andImage:(UIImage *)image{
    self = [self initWithText:text andURL:url];
    if (self) {
        self.image = image;
    }
    return self;
}
@end

@interface Catapult (private)
@property (nonatomic,strong) NSMutableArray *_textServices;
@property (nonatomic,strong) NSMutableArray *_urlServices;
@property (nonatomic,strong) NSMutableArray *_imageServices;
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
        self._textServices = [[NSMutableArray alloc] init];
        self._urlServices = [[NSMutableArray alloc] init];
        self._imageServices = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)registerService:(Class<CatapultService>)service{
    NSObject<CatapultService> *serviceObject = (NSObject<CatapultService>*)service;
    CatapultServiceType serviceType = [serviceObject.class serviceType];
    
    BOOL isValid = YES;
    
    if ([serviceObject.class appURL]) {
        isValid = [[UIApplication sharedApplication] canOpenURL:[serviceObject.class appURL]];
    }
    
    if (isValid) {
        if (serviceType &= CatapultServiceTypeText) {
            [self._textServices addObject:service];
        }
        if (serviceType &= CatapultServiceTypeURL) {
            [self._urlServices addObject:service];
        }
        if (serviceType &= CatapultServiceTypeImage) {
            [self._imageServices addObject:service];
        }
    }
    
    return isValid;
}

- (NSArray *)servicesForServiceType:(CatapultServiceType)serviceType{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (serviceType &= CatapultServiceTypeText) {
        [array addObjectsFromArray:self._textServices];
    }
    if (serviceType &= CatapultServiceTypeURL) {
        [array addObjectsFromArray:self._urlServices];
    }
    if (serviceType &= CatapultServiceTypeImage) {
        [array addObjectsFromArray:self._imageServices];
    }
    return array;
}

+ (NSArray *)serviceNameArrayForServiceArray:(NSArray *)services{
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for (NSObject<CatapultService> *service in services) {
        [names addObject:[service.class serviceName]];
    }
    return names;
}

- (void)takeAimAtServiceType:(CatapultServiceType)serviceType
                 withPayload:(CatapultPayload*)payload
          fromViewController:(UIViewController *)viewController
                 withOptions:(NSDictionary *)dictionary
                 andComplete:(void(^)(BOOL success, Class<CatapultService> selectedService))complete{
    
    NSArray *services = [self servicesForServiceType:serviceType];
    
    [UIActionSheet presentOnView:viewController.view withTitle:@"" otherButtons:[self.class serviceNameArrayForServiceArray:services] onCancel:^(UIActionSheet *sheet) {
        if (complete) {
            complete(NO,nil);
        }
    } onClickedButton:^(UIActionSheet *sheet, NSUInteger index) {
        NSObject<CatapultService> *service = [services objectAtIndex:index];
        [service.class launchPayload:payload withOptions:dictionary andComplete:^(BOOL success){
            if (complete) {
                complete(success,service.class);
            }
        }];
    }];
}
@end


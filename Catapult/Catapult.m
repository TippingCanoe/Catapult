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
- (CatapultTargetType)targetType{
    CatapultTargetType type = 0;
    if (self.text) {
        type &= CatapultTargetTypeText;
    }
    if (self.url) {
        type &= CatapultTargetTypeURL;
    }
    if (self.image) {
        type &= CatapultTargetTypeImage;
    }
    return type;
}
@end

@interface Catapult (private)
@property (nonatomic,strong) NSMutableArray *_texttargets;
@property (nonatomic,strong) NSMutableArray *_urltargets;
@property (nonatomic,strong) NSMutableArray *_imagetargets;
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
        self._texttargets = [[NSMutableArray alloc] init];
        self._urltargets = [[NSMutableArray alloc] init];
        self._imagetargets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)registerTarget:(Class<CatapultTarget>)target{
    NSObject<CatapultTarget> *targetObject = (NSObject<CatapultTarget>*)target;
    CatapultTargetType targetType = [targetObject.class targetType];
    
    BOOL isValid = YES;
    
    if ([targetObject.class appURL]) {
        isValid = [[UIApplication sharedApplication] canOpenURL:[targetObject.class appURL]];
    }
    
    if (isValid) {
        if (targetType &= CatapultTargetTypeText) {
            [self._texttargets addObject:target];
        }
        if (targetType &= CatapultTargetTypeURL) {
            [self._urltargets addObject:target];
        }
        if (targetType &= CatapultTargetTypeImage) {
            [self._imagetargets addObject:target];
        }
    }
    
    return isValid;
}

- (NSArray *)targetsFortargetType:(CatapultTargetType)targetType{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (targetType &= CatapultTargetTypeText) {
        [array addObjectsFromArray:self._texttargets];
    }
    if (targetType &= CatapultTargetTypeURL) {
        [array addObjectsFromArray:self._urltargets];
    }
    if (targetType &= CatapultTargetTypeImage) {
        [array addObjectsFromArray:self._imagetargets];
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
    
    [UIActionSheet presentOnView:viewController.view withTitle:@"" otherButtons:[self.class targetNameArrayFortargetArray:targets] onCancel:^(UIActionSheet *sheet) {
        if (complete) {
            complete(NO,nil);
        }
    } onClickedButton:^(UIActionSheet *sheet, NSUInteger index) {
        NSObject<CatapultTarget> *target = [targets objectAtIndex:index];
        [target.class launchPayload:payload withOptions:dictionary andComplete:^(BOOL success){
            if (complete) {
                complete(success,target.class);
            }
        }];
    }];
}
@end


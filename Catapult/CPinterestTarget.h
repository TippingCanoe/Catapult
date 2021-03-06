//
//  CPinterstService.h
//  Catapult
//
//  Created by Jeff on 2/10/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Catapult.h"

@interface CPinterestTarget : NSObject <CatapultTarget>
@property (nonatomic,copy) void(^complete)(BOOL complete);
+ (void)setPinterestID:(NSString *)string;
@end

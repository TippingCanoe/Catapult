//
//  CGmailTarget.h
//  Catapult
//
//  Created by Jeff on 2/11/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Catapult.h"

@interface CGmailTarget : NSObject <CatapultTarget>
@property (nonatomic,copy) void(^complete)(BOOL complete);
+ (void)setSuccessURL:(NSURL *)success;
+ (void)setCancelURL:(NSURL *)cancel;
@end

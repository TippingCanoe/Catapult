//
//  CEmailTarget.h
//  Catapult
//
//  Created by Jeff on 2/11/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Catapult.h"
#import <MessageUI/MessageUI.h>

@interface CEmailTarget : NSObject <CatapultTarget,MFMailComposeViewControllerDelegate>
@property (nonatomic,copy) void(^complete)(BOOL complete);

@end

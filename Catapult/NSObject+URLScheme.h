//
//  NSObject+URLScheme.h
//  Catapult
//
//  Created by Jeff on 2/19/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (URLScheme)
- (NSURL *)urlMatchingScheme:(NSString *)host;
@end

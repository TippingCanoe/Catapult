//
//  NSObject+URLScheme.m
//  Catapult
//
//  Created by Jeff on 2/19/2014.
//  Copyright (c) 2014 TippingCanoe. All rights reserved.
//

#import "NSObject+URLScheme.h"

@implementation NSObject (URLScheme)

- (NSURL *)urlMatchingScheme:(NSString *)host{
    if ([self isKindOfClass:NSURL.class] && [((NSURL *)self).scheme isEqualToString:host]) {
        return (NSURL *)self;
    }else if([self isKindOfClass:NSString.class] && [((NSString *)self) rangeOfString:[NSString stringWithFormat:@"%@://",host]].length > 0){
        return [NSURL URLWithString:(NSString *)self];
    }else{
        return nil;
    }
}
@end

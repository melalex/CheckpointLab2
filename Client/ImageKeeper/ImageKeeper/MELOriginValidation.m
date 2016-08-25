//
//  MELOriginValidation.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/25/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELOriginValidation.h"

@implementation MELOriginValidation

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)reverseTransformedValue:(id)value
{
    return (value != nil) ? value : @0;
}

@end

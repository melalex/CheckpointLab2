//
//  MELSizeValidation.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/25/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELSizeValidation.h"

@implementation MELSizeValidation

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)reverseTransformedValue:(id)value
{
    value = (value != nil) ? value : @0;
    return [value doubleValue] >= 10 ? value : @10;
}

@end

//
//  MELImageModel.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELImageModel.h"
#import "MELRect.h"
#import "Macros.h"

@implementation MELImageModel

- (instancetype)initWithImage:(NSImage *)image frame:(MELRect *)frame layer:(NSUInteger)layer;
{
    if (self = [self init])
    {
        _image = [image retain];
        _frame = [frame retain];
        _layer = layer;
    }
    return self;
}

#pragma mark - NSCoding

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        _image = [[aDecoder decodeObjectForKey:@"image"] retain];
        _frame = [[aDecoder decodeObjectForKey:@"frame"] retain];
        _layer = [aDecoder decodeIntegerForKey:@"layer"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.frame forKey:@"frame"];
    [aCoder encodeInteger:self.layer forKey:@"layer"];
}

@end

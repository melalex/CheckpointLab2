//
//  MELRect.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/21/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELRect.h"

@implementation MELRect

- (instancetype)initWithRect:(NSRect)rect
{
    if (self = [self init])
    {
        _x = rect.origin.x;
        _y = rect.origin.y;
        _width = rect.size.width;
        _height = rect.size.height;
    }
    return self;
}

- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    if (self = [self init])
    {
        _x = x;
        _y = y;
        _width = width;
        _height = height;
    }
    return self;
}

- (NSRect)rect
{
    return NSMakeRect(self.x, self.y, self.width, self.height);
}

#pragma mark - NSCoding

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        _x = [aDecoder decodeDoubleForKey:@"x"];
        _y = [aDecoder decodeDoubleForKey:@"y"];
        _width = [aDecoder decodeDoubleForKey:@"width"];
        _height = [aDecoder decodeDoubleForKey:@"height"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:self.x forKey:@"x"];
    [aCoder encodeDouble:self.y forKey:@"y"];
    [aCoder encodeDouble:self.width forKey:@"width"];
    [aCoder encodeDouble:self.height forKey:@"height"];
}

@end

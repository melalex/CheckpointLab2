//
//  MELPrimitiveModel.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/23/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELPrimitiveModel.h"
#import "MELRect.h"
#import "MELVisitor.h"

static NSString *const kFrame = @"frame";
static NSString *const kLayer = @"layer";

@interface MELPrimitiveModel()
{
    MELRect *_frame;
    NSUInteger _layer;
}

@end

@implementation MELPrimitiveModel

- (instancetype)initWithFrame:(MELRect *)frame layer:(NSUInteger)layer;
{
    if (self = [self init])
    {
        _frame = [frame retain];
        _layer = layer;
    }
    return self;
}

- (void)dealloc
{
    [_frame release];
    
    [super dealloc];
}

- (void)acceptVisitor:(MELVisitor *)visitor
{
    [visitor performTasks:self];
}

#pragma mark - NSCoding

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        _frame = [[aDecoder decodeObjectForKey:kFrame] retain];
        _layer = [aDecoder decodeIntegerForKey:kLayer];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.frame forKey:kFrame];
    [aCoder encodeInteger:self.layer forKey:kLayer];
}

#pragma mark - MELPrimitiveModelSetters

- (void)setFrame:(MELRect *)frame
{
    if (_frame != frame)
    {
        [_frame release];
        _frame = [frame retain];
    }
}

- (void)setLayer:(NSUInteger)layer
{
    _layer = layer;
}

#pragma mark - MELPrimitiveModelGetters

- (MELRect *)frame
{
    return _frame;
}

- (NSUInteger)layer
{
    return _layer;
}

@end

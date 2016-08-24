//
//  MELLineModel.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/23/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELLineModel.h"
#import "MELRect.h"

@interface MELLineModel()

@property NSPoint innerFirstPoint;
@property NSPoint innerSecondPoint;

@end

@implementation MELLineModel

- (void)synchronizeFrame
{
    self.frame.x = fmin(self.innerFirstPoint.x, self.innerSecondPoint.x);
    self.frame.y = fmin(self.innerFirstPoint.y, self.innerSecondPoint.y);
    self.frame.width = fabs(self.innerFirstPoint.x - self.innerSecondPoint.x);
    self.frame.height = fabs(self.innerFirstPoint.y - self.innerSecondPoint.y);
}

#pragma mark - MELLineModelSetters

- (void)setFirstPoint:(NSPoint)firstPoint
{
    self.innerFirstPoint = firstPoint;
    self.innerSecondPoint = firstPoint;

    [self synchronizeFrame];
}

- (void)setSecondPoint:(NSPoint)secondPoint
{
    self.innerSecondPoint = secondPoint;
    
    [self synchronizeFrame];
}

#pragma mark - MELLineModelGetters

- (NSPoint)firstPoint
{
    NSPoint result;
    
#warning Create is.. method
    
    if ((self.innerFirstPoint.x < self.innerSecondPoint.x && self.innerFirstPoint.y < self.innerSecondPoint.y) ||
        (self.innerFirstPoint.x > self.innerSecondPoint.x && self.innerFirstPoint.y > self.innerSecondPoint.y))
    {
        result = NSMakePoint(NSMinX(self.frame.rect), NSMinY(self.frame.rect));
    }
    else if ((self.innerFirstPoint.x < self.innerSecondPoint.x && self.innerFirstPoint.y > self.innerSecondPoint.y) ||
             (self.innerFirstPoint.x > self.innerSecondPoint.x && self.innerFirstPoint.y < self.innerSecondPoint.y))
    {
        result = NSMakePoint(NSMinX(self.frame.rect), NSMaxY(self.frame.rect));
    }
    
    return result;
}

- (NSPoint)secondPoint
{
    NSPoint result;
    
    if ((self.innerFirstPoint.x < self.innerSecondPoint.x && self.innerFirstPoint.y < self.innerSecondPoint.y) ||
        (self.innerFirstPoint.x > self.innerSecondPoint.x && self.innerFirstPoint.y > self.innerSecondPoint.y))
    {
        result = NSMakePoint(NSMaxX(self.frame.rect), NSMaxY(self.frame.rect));
    }
    else if ((self.innerFirstPoint.x < self.innerSecondPoint.x && self.innerFirstPoint.y > self.innerSecondPoint.y) ||
             (self.innerFirstPoint.x > self.innerSecondPoint.x && self.innerFirstPoint.y < self.innerSecondPoint.y))
    {
        result = NSMakePoint(NSMaxX(self.frame.rect), NSMinY(self.frame.rect));
    }
    
    return result;

    return NSMakePoint(NSMaxX(self.frame.rect), NSMaxY(self.frame.rect));
}

@end

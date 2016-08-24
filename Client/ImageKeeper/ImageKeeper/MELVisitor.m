//
//  MELVisitor.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/23/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MELVisitor.h"
#import "MELImageModel.h"
#import "MELLineModel.h"
#import "MELOvalModel.h"
#import "MELRectangleModel.h"
#import "MELCurveModel.h"
#import "MELRect.h"

@implementation MELVisitor

- (void)performTasks:(id)object;
{
    Class class = [object class];
    while (class && class != [NSObject class])
    {
        NSString *methodName = [NSString stringWithFormat:@"perform%@Tasks:", class];
        SEL selector = NSSelectorFromString(methodName);
        if ([self respondsToSelector:selector])
        {
            [self performSelector:selector withObject:object];
            return;
        }
        class = [class superclass];
    }
    
    NSException* myException = [NSException exceptionWithName:@"ObjectIsNotSupportedException"
                                                       reason:[NSString stringWithFormat:@"Visitor %@ doesn't have a performTasks method for %@", [self class], [object class]]
                                                     userInfo:nil];
    @throw myException;
}

- (void)performMELImageModelTasks:(MELImageModel *)object
{
    [object.image drawInRect:object.frame.rect fromRect:NSZeroRect operation:NSCompositeSourceAtop fraction:1.0f];
}

- (void)performMELLineModelTasks:(MELLineModel *)object
{
    NSBezierPath * path = [NSBezierPath bezierPath];
        
    [path  moveToPoint:object.firstPoint];
    [path lineToPoint:object.secondPoint];
    
    [[NSColor blackColor] set];
    [path stroke];
}

- (void)performMELOvalModelTasks:(MELOvalModel *)object
{
    
}

- (void)performMELRectangleModelTasks:(MELRectangleModel *)object
{
    
}

- (void)performMELCurveModelTasks:(MELCurveModel *)object
{
    
}

@end

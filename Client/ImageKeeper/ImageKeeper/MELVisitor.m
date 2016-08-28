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

#warning undo for color and rotating

- (void)performMELImageModelTasks:(MELImageModel *)object
{
    NSAffineTransform *rotate = [[NSAffineTransform alloc] init];
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    
    [context saveGraphicsState];
    [rotate rotateByRadians:object.rotation];
    [rotate translateXBy:-(object.frame.width / 2) yBy:-(object.frame.height / 2)];
    [rotate concat];
    
    [object.image drawInRect:object.frame.rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:object.transparency];
    
    [rotate release];
    [context restoreGraphicsState];
}

- (void)performMELLineModelTasks:(MELLineModel *)object
{
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    CGAffineTransformMakeRotation(object.rotation);
    
    [path setLineWidth:object.thickness];
    [object.color set];
    
    [path  moveToPoint:object.firstPoint];
    [path lineToPoint:object.secondPoint];
    
    [path stroke];
}

- (void)performMELOvalModelTasks:(MELOvalModel *)object
{
    NSBezierPath *oval = [NSBezierPath bezierPathWithOvalInRect:object.frame.rect];

    CGAffineTransformMakeRotation(object.rotation);
    
    [oval setLineWidth:object.thickness];
    [object.color set];
    
    [oval stroke];
}

- (void)performMELRectangleModelTasks:(MELRectangleModel *)object
{
    NSBezierPath *rectangle = [NSBezierPath bezierPathWithRect:object.frame.rect];
    
    CGAffineTransformMakeRotation(object.rotation);
    
    [rectangle setLineWidth:object.thickness];
    [object.color set];
    
    [rectangle stroke];
}

- (void)performMELCurveModelTasks:(MELCurveModel *)object
{
    
}

@end

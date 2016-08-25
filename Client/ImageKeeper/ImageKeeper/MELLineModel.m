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

- (BOOL)isFirstOrThirdQuarter
{
    return (self.innerFirstPoint.x < self.innerSecondPoint.x && self.innerFirstPoint.y < self.innerSecondPoint.y) ||
           (self.innerFirstPoint.x > self.innerSecondPoint.x && self.innerFirstPoint.y > self.innerSecondPoint.y);
}

- (BOOL)isSecondOrFourthQuarter
{
    return (self.innerFirstPoint.x < self.innerSecondPoint.x && self.innerFirstPoint.y > self.innerSecondPoint.y) ||
           (self.innerFirstPoint.x > self.innerSecondPoint.x && self.innerFirstPoint.y < self.innerSecondPoint.y);
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
        
    if ([self isFirstOrThirdQuarter])
    {
        result = NSMakePoint(NSMinX(self.frame.rect), NSMinY(self.frame.rect));
    }
    else if ([self isSecondOrFourthQuarter])
    {
        result = NSMakePoint(NSMinX(self.frame.rect), NSMaxY(self.frame.rect));
    }
    
    return result;
}

- (NSPoint)secondPoint
{
    NSPoint result;
    
    if ([self isFirstOrThirdQuarter])
    {
        result = NSMakePoint(NSMaxX(self.frame.rect), NSMaxY(self.frame.rect));
    }
    else if ([self isSecondOrFourthQuarter])
    {
        result = NSMakePoint(NSMaxX(self.frame.rect), NSMinY(self.frame.rect));
    }
    
    return result;

    return NSMakePoint(NSMaxX(self.frame.rect), NSMaxY(self.frame.rect));
}

#pragma mark - NSPasteboardWriting

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard
{
    static NSArray *writableTypes = nil;
    
    if (!writableTypes)
    {
        writableTypes = [NSArray arrayWithObject:kMELElementUTI];
    }
    
    return writableTypes;
}

- (id)pasteboardPropertyListForType:(NSString *)type
{
    NSData *result = nil;
    
    if ([type isEqualToString:kMELElementUTI])
    {
        result = [NSKeyedArchiver archivedDataWithRootObject:self];
    }
    
    return result;
}

#pragma mark - NSPasteboardReading

+ (NSArray *)readableTypesForPasteboard:(NSPasteboard *)pasteboard
{
    static NSArray *readableTypes = nil;
    
    if (!readableTypes)
    {
        readableTypes = [NSArray arrayWithObject:kMELElementUTI];
    }
    
    return readableTypes;
}

+ (NSPasteboardReadingOptions)readingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pboard
{
    NSPasteboardReadingOptions result = 0;
    
    if ([type isEqualToString:kMELElementUTI])
    {
        result = NSPasteboardReadingAsKeyedArchive;
    }
    
    return result;
}

@end

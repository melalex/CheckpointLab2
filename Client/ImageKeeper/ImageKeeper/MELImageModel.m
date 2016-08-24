//
//  MELImageModel.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELImageModel.h"
#import "MELRect.h"
#import "MELVisitor.h"

static NSString *const kImage = @"image";
static NSString *const kFrame = @"frame";
static NSString *const kLayer = @"layer";


@interface MELImageModel()
{
    MELRect *_frame;
    NSUInteger _layer;
}

@end

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

- (void)dealloc
{
    [_frame release];
    
    [super dealloc];
}

- (void)acceptVisitor:(MELVisitor *)visitor
{
    [visitor performTasks:self];
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


#pragma mark - NSCoding

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        _image = [[aDecoder decodeObjectForKey:kImage] retain];
        _frame = [[aDecoder decodeObjectForKey:kFrame] retain];
        _layer = [aDecoder decodeIntegerForKey:kLayer];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.image forKey:kImage];
    [aCoder encodeObject:self.frame forKey:kFrame];
    [aCoder encodeInteger:self.layer forKey:kLayer];
}

#pragma mark - MELImageModelSetters

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

#pragma mark - MELImageModelGetters

- (MELRect *)frame
{
    return _frame;
}

- (NSUInteger)layer
{
    return _layer;
}

@end

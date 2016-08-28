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
#import "Macros.h"

static NSString *const kImage = @"image";
static NSString *const kFrame = @"frame";
static NSString *const kLayer = @"layer";
static NSString *const kRotation = @"rotation";
static NSString *const kTransparency = @"transparency";

@interface MELImageModel()
{
    MELRect *_frame;
    NSUInteger _layer;
}

@end

@implementation MELImageModel

- (instancetype)init
{
    if (self = [super init])
    {
        _image = nil;
        _frame = nil;
        _layer = 0;
        _rotation = 0;
        _transparency = 1.0;
    }
    return self;
}

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

- (void)addObserver:(id)observer context:(NSString *)context;
{
    [self.frame addObserver:observer
            forKeyPath:@OBJECT_KEY_PATH(self.frame, x)
               options:NSKeyValueObservingOptionOld
               context:(__bridge void * _Nullable)(context)];
    
    [self.frame addObserver:observer
            forKeyPath:@OBJECT_KEY_PATH(self.frame, y)
               options:NSKeyValueObservingOptionOld
               context:(__bridge void * _Nullable)(context)];
    
    [self.frame addObserver:observer
            forKeyPath:@OBJECT_KEY_PATH(self.frame, width)
               options:NSKeyValueObservingOptionOld
               context:(__bridge void * _Nullable)(context)];
    
    [self.frame addObserver:observer
            forKeyPath:@OBJECT_KEY_PATH(self.frame, height)
               options:NSKeyValueObservingOptionOld
               context:(__bridge void * _Nullable)(context)];
    
    [self addObserver:observer
           forKeyPath:@OBJECT_KEY_PATH(self, layer)
              options:NSKeyValueObservingOptionOld
              context:(__bridge void * _Nullable)(context)];
    
    [self addObserver:observer
           forKeyPath:@OBJECT_KEY_PATH(self, rotation)
              options:NSKeyValueObservingOptionOld
              context:(__bridge void * _Nullable)(context)];
    
    [self addObserver:observer
           forKeyPath:@OBJECT_KEY_PATH(self, transparency)
              options:NSKeyValueObservingOptionOld
              context:(__bridge void * _Nullable)(context)];
}

- (void)removeObserver:(id)observer context:(NSString *)context
{
    [self.frame removeObserver:self
                    forKeyPath:@OBJECT_KEY_PATH(self.frame, x)
                       context:context];
    
    [self.frame removeObserver:self
                    forKeyPath:@OBJECT_KEY_PATH(self.frame, y)
                       context:context];
    
    [self.frame removeObserver:self
                    forKeyPath:@OBJECT_KEY_PATH(self.frame, width)
                       context:context];
    
    [self.frame removeObserver:self
                    forKeyPath:@OBJECT_KEY_PATH(self.frame, height)
                       context:context];
    
    [self removeObserver:self
              forKeyPath:@OBJECT_KEY_PATH(self, layer)
                 context:context];
    
    [self removeObserver:self
              forKeyPath:@OBJECT_KEY_PATH(self, rotation)
                 context:context];
    
    [self removeObserver:self
              forKeyPath:@OBJECT_KEY_PATH(self, transparency)
                 context:context];
}

#pragma mark - NSPasteboardWriting

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard
{
    static NSArray *writableTypes = nil;
    
    if (!writableTypes)
    {
        writableTypes = [[NSArray alloc] initWithObjects:kMELElementUTI, nil];
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
        readableTypes = [[NSArray alloc] initWithObjects:kMELElementUTI, nil];
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
        _rotation = [aDecoder decodeDoubleForKey:kRotation];
        _transparency = [aDecoder decodeDoubleForKey:kTransparency];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.image forKey:kImage];
    [aCoder encodeObject:self.frame forKey:kFrame];
    [aCoder encodeInteger:self.layer forKey:kLayer];
    [aCoder encodeDouble:self.rotation forKey:kRotation];
    [aCoder encodeDouble:self.transparency forKey:kTransparency];
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

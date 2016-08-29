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
#import "Macros.h"

#import <Cocoa/Cocoa.h>

static NSString *const kFrame = @"frame";
static NSString *const kLayer = @"layer";
static NSString *const kFigureColor = @"color";
static NSString *const kThickness = @"thickness";
static NSString *const kRotation = @"rotation";
static NSString *const kTransparency = @"transparency";

@interface MELPrimitiveModel()
{
    MELRect *_frame;
    NSUInteger _layer;
    CGFloat _rotation;
}

@end

@implementation MELPrimitiveModel

- (instancetype)init
{
    if (self = [super init])
    {
        _color = nil;
        _frame = nil;
        _layer = 0;
        _rotation = 0;
        _transparency = 1.0;
        _thickness = 1;
    }
    return self;
}

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
    [_color release];
    
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
           forKeyPath:@OBJECT_KEY_PATH(self, color)
              options:NSKeyValueObservingOptionOld
              context:(__bridge void * _Nullable)(context)];

    [self addObserver:observer
           forKeyPath:@OBJECT_KEY_PATH(self, thickness)
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
              forKeyPath:@OBJECT_KEY_PATH(self, color)
                 context:context];
    
    [self removeObserver:self
              forKeyPath:@OBJECT_KEY_PATH(self, thickness)
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
    return nil;
}

- (id)pasteboardPropertyListForType:(NSString *)type
{
    return nil;
}

#pragma mark - NSPasteboardReading

+ (NSArray *)readableTypesForPasteboard:(NSPasteboard *)pasteboard
{
    return nil;
}

+ (NSPasteboardReadingOptions)readingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pboard
{
    return 0;
}


#pragma mark - NSCoding

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        _color = [[aDecoder decodeObjectForKey:kFigureColor] retain];
        _thickness = [aDecoder decodeIntegerForKey:kThickness];
        _frame = [[aDecoder decodeObjectForKey:kFrame] retain];
        _layer = [aDecoder decodeIntegerForKey:kLayer];
        _rotation = [aDecoder decodeDoubleForKey:kRotation];
        _transparency = [aDecoder decodeDoubleForKey:kTransparency];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.color forKey:kFigureColor];
    [aCoder encodeInteger:self.thickness forKey:kThickness];
    [aCoder encodeObject:self.frame forKey:kFrame];
    [aCoder encodeInteger:self.layer forKey:kLayer];
    [aCoder encodeDouble:self.rotation forKey:kRotation];
    [aCoder encodeDouble:self.transparency forKey:kTransparency];
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

- (void)setRotation:(CGFloat)rotation
{
    _rotation = rotation;
    self.frame.rotation = rotation;
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

- (CGFloat)rotation
{
    return _rotation;
}

@end

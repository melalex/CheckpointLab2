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

static NSString *const kMELImageModelContextFrame = @"kMELImageModelContextFrame";

NSString *const kMELImageModelDidChangeFrameNotification = @"kMELImageModelDidChangeFrameNotification";

@implementation MELImageModel

- (instancetype)initWithImage:(NSImage *)image frame:(MELRect *)frame layer:(NSUInteger)layer;
{
    if (self = [self init])
    {
        _image = image;
        _frame = frame;
        _layer = layer;
        
        [_frame addObserver:self forKeyPath:@OBJECT_KEY_PATH(_frame, x)
                    options:NSKeyValueObservingOptionOld
                    context:(__bridge void *_Nullable)(kMELImageModelContextFrame)];
        
        [_frame addObserver:self forKeyPath:@OBJECT_KEY_PATH(_frame, y)
                    options:NSKeyValueObservingOptionOld
                    context:(__bridge void *_Nullable)(kMELImageModelContextFrame)];

        [_frame addObserver:self forKeyPath:@OBJECT_KEY_PATH(_frame, width)
                    options:NSKeyValueObservingOptionOld
                    context:(__bridge void *_Nullable)(kMELImageModelContextFrame)];

        [_frame addObserver:self forKeyPath:@OBJECT_KEY_PATH(_frame, height)
                    options:NSKeyValueObservingOptionOld
                    context:(__bridge void *_Nullable)(kMELImageModelContextFrame)];

        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)anObject change:(NSDictionary<NSString *,id> *)aChange context:(void *)aContext
{
    if (aContext == (__bridge void *_Nullable)(kMELImageModelContextFrame))
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kMELImageModelDidChangeFrameNotification object:anObject];
    }
    else
    {
        [super observeValueForKeyPath:aKeyPath ofObject:anObject change:aChange context:aContext];
    }
}


@end

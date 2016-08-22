//
//  MELCanvasController.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELCanvasController.h"
#import "MELDataStore.h"
#import "Macros.h"
#import "MELCanvas.h"
#import "MELDocumentModel.h"
#import "MELImageModel.h"
#import "MELRect.h"

static NSString *const kMELCanvasControllerContextImageToDraw = @"kMELCanvasControllerContextImageToDraw";
static NSString *const kMELCanvasControllerContextImageChangeFrame = @"kMELCanvasControllerContextImageChangeFrame";
static NSString *const kMELCanvasControllerContextSelectedImageChanged = @"kMELCanvasControllerContextSelectedImageChanged";

@interface MELCanvasController ()
{
    MELDataStore *_dataStore;
}


@end

@implementation MELCanvasController

- (void)dealloc
{
    [_dataStore removeObserver:self forKeyPath:@OBJECT_KEY_PATH(_dataStore, documentModel.imagesToDraw) context:(__bridge void * _Nullable)(kMELCanvasControllerContextImageToDraw)];
   
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_dataStore release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
}

- (void)addImageFromLibraryAtIndex:(NSUInteger)index toPoint:(NSPoint)point
{
    NSImage *image = self.dataStore.images[index];
    MELRect *frame = [[MELRect alloc] initWithX:point.x y:point.y width:image.size.width height:image.size.height];
    
    [self.dataStore putToDocumentModelImage:image inFrame:frame];
}

- (void)selectImageInPoint:(NSPoint)point
{
    [self.dataStore selectImageInPoint:point];
}

- (BOOL)isSelected:(MELImageModel *)image
{
    BOOL result = NO;
    
    if (image == self.dataStore.selectedImage)
    {
        result = YES;
    }
    
    return result;
}

- (NSUInteger)takeTopLayer
{
    NSUInteger topLayer = 0;
    
    for (MELImageModel *image in self.dataStore.documentModel.imagesToDraw)
    {
        if (image.layer > topLayer)
        {
            topLayer = image.layer;
        }
    }
    
    return topLayer;
}

#pragma mark - MELCanvasController KVO

- (void)setDataStore:(MELDataStore *)dataStore
{
    if (_dataStore != dataStore)
    {
        [_dataStore removeObserver:self forKeyPath:@OBJECT_KEY_PATH(_dataStore, documentModel.imagesToDraw) context:(__bridge void * _Nullable)(kMELCanvasControllerContextImageToDraw)];
        [_dataStore removeObserver:self forKeyPath:@OBJECT_KEY_PATH(_dataStore, selectedImage) context:(__bridge void * _Nullable)(kMELCanvasControllerContextSelectedImageChanged)];

        [_dataStore release];
        _dataStore = [dataStore retain];
        
        [_dataStore addObserver:self forKeyPath:@OBJECT_KEY_PATH(_dataStore, documentModel.imagesToDraw)
                        options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                        context:(__bridge void * _Nullable)(kMELCanvasControllerContextImageToDraw)];
        
        [_dataStore addObserver:self forKeyPath:@OBJECT_KEY_PATH(_dataStore, selectedImage)
                        options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                        context:(__bridge void * _Nullable)(kMELCanvasControllerContextSelectedImageChanged)];
    }
}

- (MELDataStore *)dataStore
{
    return _dataStore;
}

#warning create consts for strings
#warning wrong frames

- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)anObject change:(NSDictionary<NSString *,id> *)aChange context:(void *)aContext
{
    if (aContext == (__bridge void * _Nullable)(kMELCanvasControllerContextImageToDraw))
    {
        NSUInteger index = [(NSIndexSet *)aChange[@"indexes"] firstIndex];
        
        NSArray<MELImageModel *> *images = self.dataStore.documentModel.imagesToDraw;
        MELRect *frame = [images[index] frame];
        
        [frame addObserver:self forKeyPath:@OBJECT_KEY_PATH(frame, x)
                    options:NSKeyValueObservingOptionOld
                    context:(__bridge void *_Nullable)(kMELCanvasControllerContextImageChangeFrame)];
        
        [frame addObserver:self forKeyPath:@OBJECT_KEY_PATH(frame, y)
                    options:NSKeyValueObservingOptionOld
                    context:(__bridge void *_Nullable)(kMELCanvasControllerContextImageChangeFrame)];
        
        [frame addObserver:self forKeyPath:@OBJECT_KEY_PATH(frame, width)
                    options:NSKeyValueObservingOptionOld
                    context:(__bridge void *_Nullable)(kMELCanvasControllerContextImageChangeFrame)];
        
        [frame addObserver:self forKeyPath:@OBJECT_KEY_PATH(frame, height)
                    options:NSKeyValueObservingOptionOld
                    context:(__bridge void *_Nullable)(kMELCanvasControllerContextImageChangeFrame)];

        self.canvas.imagesToDraw = images;
                
        [self.view setNeedsDisplayInRect:frame.rect];
    }
    else if (aContext == (__bridge void * _Nullable)(kMELCanvasControllerContextImageChangeFrame))
    {
        NSRect rect = [(MELRect *)anObject rect];
        CGFloat oldValue = [aChange[@"old"] doubleValue];
        
        if ([aKeyPath isEqualToString:@"x"])
        {
            NSInteger dX = fabs(oldValue - rect.origin.x);
            rect.size.width += dX;
            rect.origin.x = fmin(rect.origin.x, oldValue);
        }
        else if ([aKeyPath isEqualToString:@"y"])
        {
            NSInteger dY = fabs(oldValue - rect.origin.y);
            rect.size.height += dY;
            rect.origin.y = fmin(rect.origin.y, oldValue);
        }
        else if ([aKeyPath isEqualToString:@"width"])
        {
            rect.size.width += fmax(rect.size.width, oldValue);
        }
        else if ([aKeyPath isEqualToString:@"height"])
        {
            rect.size.height += fmax(rect.size.height, oldValue);
        }
        
        [self.view setNeedsDisplayInRect:rect];
    }
    else if (aContext == (__bridge void * _Nullable)(kMELCanvasControllerContextSelectedImageChanged))
    {
        self.view.needsDisplay = YES;
    }
    else
    {
        [super observeValueForKeyPath:aKeyPath ofObject:anObject change:aChange context:aContext];
    }
}

- (MELCanvas *)canvas
{
    return (MELCanvas *)self.view;
}

@end

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

@interface MELCanvasController ()
{
    MELDataStore *_dataStore;
}


@end

@implementation MELCanvasController

- (void)dealloc
{
    [_dataStore removeObserver:self forKeyPath:@OBJECT_KEY_PATH(_dataStore, documentModel.imagesToDraw) context:(__bridge void * _Nullable)(kMELCanvasControllerContextImageToDraw)];

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

- (void)selectImageinPoint:(NSPoint)point
{
    [self.dataStore selectImageInPoint:point];
}

- (void)setDataStore:(MELDataStore *)dataStore
{
    if (_dataStore != dataStore)
    {
        [_dataStore removeObserver:self forKeyPath:@OBJECT_KEY_PATH(_dataStore, documentModel.imagesToDraw) context:(__bridge void * _Nullable)(kMELCanvasControllerContextImageToDraw)];
        
        [_dataStore release];
        _dataStore = [dataStore retain];
        
        [_dataStore addObserver:self forKeyPath:@OBJECT_KEY_PATH(_dataStore, documentModel.imagesToDraw)
                        options:NSKeyValueObservingOptionNew
                        context:(__bridge void *_Nullable)(kMELCanvasControllerContextImageToDraw)];

    }
}

- (MELDataStore *)dataStore
{
    return _dataStore;
}

- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)anObject change:(NSDictionary<NSString *,id> *)aChange context:(void *)aContext
{
    if (aContext == (__bridge void *_Nullable)(kMELCanvasControllerContextImageToDraw))
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        NSArray<MELImageModel *> *images = self.dataStore.documentModel.imagesToDraw;
        
        for (MELImageModel *image in images)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(frameDidChange:) name:kMELImageModelDidChangeFrameNotification object:image];
        }
        
        self.canvas.imagesToDraw = images;
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

- (void)frameDidChange:(NSNotification *)notification
{
    [self.view setNeedsDisplayInRect:[(MELRect *)[notification object] rect]];
}

@end

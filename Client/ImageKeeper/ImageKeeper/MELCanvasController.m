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

static NSString *const kIndexes = @"indexes";
static NSString *const kOld = @"old";
static NSString *const kNew = @"new";

static NSString *const kX = @"x";
static NSString *const kY = @"y";
static NSString *const kWidth = @"width";
static NSString *const kHeight = @"height";
static NSString *const kLayer = @"layer";


@interface MELCanvasController ()
{
    MELDataStore *_dataStore;
}

@end

@implementation MELCanvasController

- (void)dealloc
{
    [_dataStore removeObserver:self
                    forKeyPath:@OBJECT_KEY_PATH(_dataStore, documentModel.imagesToDraw)
                       context:(__bridge void * _Nullable)(kMELCanvasControllerContextImageToDraw)];
    
    [_dataStore removeObserver:self
                    forKeyPath:@OBJECT_KEY_PATH(_dataStore, selectedImage)
                       context:(__bridge void * _Nullable)(kMELCanvasControllerContextSelectedImageChanged)];

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
 
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat x = point.x - image.size.width/2;
    CGFloat y = point.y - image.size.height/2;

    MELRect *frame = [[MELRect alloc] initWithX:x y:y width:width height:height];
    
    [self.dataStore putToDocumentModelImage:image inFrame:frame];
}

- (NSImage *)imageAtIndex:(NSUInteger)index
{
    return self.dataStore.images[index];
}

- (void)selectImageInPoint:(NSPoint)point
{
    [self.dataStore selectImageInPoint:point];
}

- (void)shiftByDeltaX:(CGFloat)deltaX deltaY:(CGFloat)deltaY
{
    self.dataStore.selectedImage.frame.x += deltaX;
    self.dataStore.selectedImage.frame.y -= deltaY;
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

- (NSRect)selectedImageFrame
{
    return self.dataStore.selectedImage.frame.rect;
}

#pragma mark - Edit commands

- (void)copySelectedImage
{
    MELImageModel *imageModel = self.dataStore.selectedImage;
    
    if (imageModel != nil)
    {
        NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:imageModel];
        [pasteboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:self];
        
        [pasteboard setData:data forType:NSStringPboardType];
    }
}

- (void)paste
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSData *data = [pasteboard dataForType:NSStringPboardType];
    MELImageModel *imageModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSRect pointRect = NSMakeRect(NSEvent.mouseLocation.x - imageModel.frame.width / 2, NSEvent.mouseLocation.y - imageModel.frame.height / 2, 0, 0);
    NSPoint mouseLocation = [self.view convertPoint:[self.view.window convertRectFromScreen:pointRect].origin
                                           fromView:nil];
    
    imageModel.frame.x = mouseLocation.x;
    imageModel.frame.y = mouseLocation.y;

    [self.dataStore putToDocumentModelImageModel:imageModel];

}

- (void)deleteSelectedImage
{
    
}

#pragma mark - MELCanvasController KVO

- (void)setDataStore:(MELDataStore *)dataStore
{
    if (_dataStore != dataStore)
    {
        [_dataStore removeObserver:self
                        forKeyPath:@OBJECT_KEY_PATH(_dataStore, documentModel.imagesToDraw)
                           context:(__bridge void * _Nullable)(kMELCanvasControllerContextImageToDraw)];
        
        [_dataStore removeObserver:self
                        forKeyPath:@OBJECT_KEY_PATH(_dataStore, selectedImage)
                           context:(__bridge void * _Nullable)(kMELCanvasControllerContextSelectedImageChanged)];

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

- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)anObject change:(NSDictionary<NSString *,id> *)aChange context:(void *)aContext
{
    if (aContext == (__bridge void * _Nullable)(kMELCanvasControllerContextImageToDraw))
    {
        NSUInteger index = [(NSIndexSet *)aChange[kIndexes] firstIndex];
        
        NSArray<MELImageModel *> *images = self.dataStore.documentModel.imagesToDraw;
        MELImageModel *image = images[index];
        MELRect *frame = [image frame];
        
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
        
        [image addObserver:self forKeyPath:@OBJECT_KEY_PATH(image, layer)
                   options:NSKeyValueObservingOptionOld
                   context:(__bridge void *_Nullable)(kMELCanvasControllerContextImageChangeFrame)];


        [self.canvas addImagesToDrawObject:image];
                
        [self.view setNeedsDisplayInRect:frame.rect];
    }
    else if (aContext == (__bridge void * _Nullable)(kMELCanvasControllerContextImageChangeFrame))
    {
        NSRect rect = [aKeyPath isEqualToString:kLayer] ? [[(MELImageModel *)anObject frame] rect] : [(MELRect *)anObject rect];
        CGFloat oldValue = [aChange[kOld] doubleValue];
        
        if ([aKeyPath isEqualToString:kX])
        {
            NSInteger dX = fabs(oldValue - rect.origin.x);
            rect.size.width += dX + 0.5;
            rect.origin.x = fmin(rect.origin.x, oldValue);
        }
        else if ([aKeyPath isEqualToString:kY])
        {
            NSInteger dY = fabs(oldValue - rect.origin.y);
            rect.size.height += dY;
            rect.origin.y = fmin(rect.origin.y, oldValue);
        }
        else if ([aKeyPath isEqualToString:kWidth])
        {
            rect.size.width += fmax(rect.size.width, oldValue);
        }
        else if ([aKeyPath isEqualToString:kHeight])
        {
            rect.size.height += fmax(rect.size.height, oldValue);
        }
        
        [self.view setNeedsDisplayInRect:rect];
    }
    else if (aContext == (__bridge void * _Nullable)(kMELCanvasControllerContextSelectedImageChanged))
    {
        if (![aChange[kOld] isEqual:[NSNull null]])
        {
            NSRect oldValue = [[(MELImageModel *)aChange[kOld] frame] rect];
            
            [self.view setNeedsDisplayInRect:oldValue];
        }
        
        if (![aChange[kNew] isEqual:[NSNull null]])
        {
            NSRect newValue = [[(MELImageModel *)aChange[kNew] frame] rect];

            [self.view setNeedsDisplayInRect:newValue];
        }

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

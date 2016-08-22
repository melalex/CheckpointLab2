//
//  MELCanvas.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELCanvas.h"
#import "MELImageModel.h"
#import "MELCanvasController.h"
#import "MELRect.h"

@interface MELCanvas()
{
    NSMutableArray<MELImageModel *> *_mutableImagesToDraw;
}

@property (readonly, retain) NSMutableArray<MELImageModel *> *mutableImagesToDraw;

@end

@implementation MELCanvas

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame:frameRect])
    {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSTIFFPboardType, NSFilenamesPboardType, NSStringPboardType, nil]];
}

- (void)dealloc
{
    [_mutableImagesToDraw release];
    
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);

    [super drawRect:dirtyRect];
    
    [self.mutableImagesToDraw sortUsingComparator:^NSComparisonResult(MELImageModel *a, MELImageModel *b)
     {
         return (NSComparisonResult)(a.layer > b.layer);
     }];

    
    for (MELImageModel *image in self.imagesToDraw)
    {
        [image.image drawInRect:image.frame.rect fromRect:NSZeroRect operation:NSCompositeSourceAtop fraction:1.0f];
        
        if ([self.controller isSelected:image])
        {
            [NSGraphicsContext saveGraphicsState];
            NSSetFocusRingStyle(NSFocusRingOnly);
            [[NSBezierPath bezierPathWithRect:NSInsetRect(image.frame.rect, 4, 4)] fill];
            [NSGraphicsContext restoreGraphicsState];
        }
    }
}

- (BOOL)isFlipped
{
    return NO;
}

#pragma mark - imagesToDraw assessors

- (void)addImagesToDrawObject:(MELImageModel *)object
{
    [self.mutableimagesToDraw addObject:object];
}

- (void)removeImagesToDrawObject:(MELImageModel *)object
{
    [self.mutableimagesToDraw removeObject:object];
}

- (NSArray<MELImageModel *> *)imagesToDraw
{
    return [[(NSArray<MELImageModel *> *)self.mutableimagesToDraw copy] autorelease];
}

- (NSMutableArray<MELImageModel *> *)mutableimagesToDraw
{
    if (!_mutableImagesToDraw)
    {
        _mutableImagesToDraw = [[NSMutableArray alloc] init];
    }
    return _mutableImagesToDraw;
}

#pragma mark - mouseEvents

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint point = [self convertPoint:[theEvent locationInWindow] toView:self];
    
    [self.controller selectImageInPoint:point];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint point = [self convertPoint:[theEvent locationInWindow] toView:self];
    NSRect selectedImageFrame = self.controller.selectedImageFrame;
    
    if (NSPointInRect(point, selectedImageFrame))
    {
        [self.controller shiftByDeltaX:theEvent.deltaX deltaY:theEvent.deltaY];
    }
}

#pragma mark - NSDraggingDestination

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{    
    return NSDragOperationCopy;
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSData *data = [[sender draggingPasteboard] dataForType:NSStringPboardType];
    NSArray *rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    [self.controller addImageFromLibraryAtIndex:[rowIndexes[0] longLongValue] toPoint:sender.draggingLocation];
    
    return YES;
}

@end

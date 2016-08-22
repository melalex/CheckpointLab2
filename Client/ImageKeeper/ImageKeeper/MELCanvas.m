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
    NSMutableArray<MELImageModel *> *_mutableimagesToDraw;
}

@property (readonly, retain) NSMutableArray<MELImageModel *> *mutableimagesToDraw;

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
    [_mutableimagesToDraw release];
    
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);

    [super drawRect:dirtyRect];
    
    NSUInteger topLayer = self.controller.takeTopLayer;
    
    for (NSUInteger i = 0; i <= topLayer; i++)
    {
        for (MELImageModel *image in self.imagesToDraw)
        {
            if (image.layer == i)
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
    if (!_mutableimagesToDraw)
    {
        _mutableimagesToDraw = [[NSMutableArray alloc] init];
    }
    return _mutableimagesToDraw;
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

#pragma mark - NSDraggingDestination

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    NSDragOperation result = NSDragOperationNone;
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric)
    {
        result = NSDragOperationGeneric;
    }
    return result;
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    return YES;
}

- (void)draggingEnded:(id<NSDraggingInfo>)sender
{
    NSData *data = [[sender draggingPasteboard] dataForType:NSStringPboardType];
    NSArray *rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    [self.controller addImageFromLibraryAtIndex:[rowIndexes[0] longLongValue] toPoint:sender.draggingLocation];
}

@end

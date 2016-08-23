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

static CGFloat const kDefaultDeltaX = 1.0;
static CGFloat const kDefaultDeltaY = 1.0;

@interface MELCanvas()

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
    [_imagesToDraw release];
    
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);

    [super drawRect:dirtyRect];
    
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

#pragma mark - mouseEvents

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    [self.controller selectImageInPoint:point];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSRect selectedImageFrame = self.controller.selectedImageFrame;
    
    if (NSPointInRect(point, selectedImageFrame))
    {
#warning optimize deltaX, deltaY
        [self.controller shiftByDeltaX:theEvent.deltaX deltaY:theEvent.deltaY];
    }
    else
    {
        [super mouseDragged:theEvent];
    }
}
#pragma mark - keyboardEvents

- (void)keyDown:(NSEvent *)theEvent
{
    NSString* const character = [theEvent charactersIgnoringModifiers];
    unichar const code = [character characterAtIndex:0];
    
    switch (code)
    {
        case NSUpArrowFunctionKey:
            [self.controller shiftByDeltaX:0 deltaY:-kDefaultDeltaY];
            break;
        
        case NSDownArrowFunctionKey:
            [self.controller shiftByDeltaX:0 deltaY:kDefaultDeltaY];
            break;
        
        case NSLeftArrowFunctionKey:
            [self.controller shiftByDeltaX:-kDefaultDeltaX deltaY:0];
            break;
        
        case NSRightArrowFunctionKey:
            [self.controller shiftByDeltaX:kDefaultDeltaX deltaY:0];
            break;
            
        default:
            [super keyDown:theEvent];
            break;
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

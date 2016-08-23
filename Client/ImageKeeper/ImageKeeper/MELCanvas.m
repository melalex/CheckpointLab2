//
//  MELCanvas.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELCanvas.h"
#import "MELCanvasController.h"
#import "MELVisitor.h"
#import "MELRect.h"

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
    [_elements release];
    
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);

    [super drawRect:dirtyRect];
    
    MELVisitor *drawer = [[MELVisitor alloc] init];
    
    for (id<MELElement> element in self.elements)
    {
        [element acceptVisitor:drawer];
        
        if ([self.controller isSelected:element])
        {
            [NSGraphicsContext saveGraphicsState];
            
            NSSetFocusRingStyle(NSFocusRingOnly);
            
            [[NSBezierPath bezierPathWithRect:NSInsetRect(element.frame.rect, 4, 4)] fill];
            [NSGraphicsContext restoreGraphicsState];
        }
    }
}

- (BOOL)isFlipped
{
    return NO;
}

- (BOOL)acceptsFirstResponder
{
    return YES;
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

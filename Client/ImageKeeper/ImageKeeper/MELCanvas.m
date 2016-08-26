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
#import "MELNumber.h"

@interface MELCanvas() <NSDraggingDestination>

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
    NSMutableArray *types = [NSMutableArray arrayWithArray:[NSImage imageTypes]];
    [types addObjectsFromArray:[NSURL readableTypesForPasteboard:[NSPasteboard generalPasteboard]]];
    [types addObject:kMELNumberUTI];
    [self registerForDraggedTypes:types];
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
    
    [drawer release];
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
    NSPasteboard *board = sender.draggingPasteboard;
    
    BOOL result = [NSImage canInitWithPasteboard:board];
    
    if (!result)
    {
        NSURL *url = [NSURL URLFromPasteboard:board];
        if (url)
        {
            result = !![[[NSImage alloc] initWithContentsOfURL:url] autorelease];
        }
    }
    
    if (!result)
    {
        NSArray *classArray = [NSArray arrayWithObject:[MELNumber class]];
        NSDictionary *options = [NSDictionary dictionary];
        
        result = [board canReadObjectForClasses:classArray options:options];
    }
    
    return result;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *board = sender.draggingPasteboard;
    NSImage *image = nil;
    NSPoint point = [self convertPoint:sender.draggingLocation fromView:nil];
    BOOL result = NO;
    
    image = [[NSImage alloc] initWithPasteboard:board];
    
    if (!image)
    {
        NSURL *url = [NSURL URLFromPasteboard:board];
        image = [[NSImage alloc] initWithContentsOfURL:url];
    }
    
    if (image)
    {
        [self.controller addImage:image toPoint:point];
        
        [image release];
        
        result = YES;
    }
    else
    {
        NSArray *classArray = [NSArray arrayWithObject:[MELNumber class]];
        NSDictionary *options = [NSDictionary dictionary];
        
        BOOL ok = [board canReadObjectForClasses:classArray options:options];
        
        if (ok)
        {
            NSArray *objectsToPaste = [board readObjectsForClasses:classArray options:options];
            MELNumber *row = [objectsToPaste objectAtIndex:0];
            
            [self.controller addImageFromLibraryAtIndex:[row integerValue] toPoint:point];
            
            result = YES;
        }
    }
    
    return result;
}

@end

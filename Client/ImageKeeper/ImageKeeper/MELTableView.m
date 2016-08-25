//
//  MELTableView.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/25/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELTableView.h"

@interface MELTableView() <NSDraggingDestination>

@end

@implementation MELTableView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib
{
    NSMutableArray *types = [NSMutableArray arrayWithArray:[NSImage imageTypes]];
    [types addObjectsFromArray:[NSURL readableTypesForPasteboard:[NSPasteboard generalPasteboard]]];
    [self registerForDraggedTypes:types];
}

-(BOOL)validateProposedFirstResponder:(NSResponder *)responder forEvent:(NSEvent *)event
{
    return event.type == NSLeftMouseDown;
}

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
            result = !![[NSImage alloc] initWithContentsOfURL:url];
        }
    }
    
    return result;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *board = sender.draggingPasteboard;
    NSImage *image = nil;
    
    image = [[NSImage alloc] initWithPasteboard:board];
    
    if (!image)
    {
        NSURL *url = [NSURL URLFromPasteboard:board];
        image = [[NSImage alloc] initWithContentsOfURL:url];
    }
    
    if (image)
    {        
        [self.controller addImage:image];
    }
    
    return !!image;
}

@end

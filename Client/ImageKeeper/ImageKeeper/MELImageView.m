//
//  MELImageView.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/25/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELImageView.h"

@interface MELImageView() <NSDraggingSource>

@property (readonly) NSInteger row;

@end

@implementation MELImageView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (BOOL)becomeFirstResponder
{
    return YES;
}

- (NSDragOperation)draggingSession:(NSDraggingSession *)aSession sourceOperationMaskForDraggingContext:(NSDraggingContext)aContext
{
    return self.image ? NSDragOperationCopy : NSDragOperationNone;
}

#warning Dragg index

- (void)mouseDown:(NSEvent *)theEvent
{
    NSImage *image = self.image;
        
    if (image)
    {
        NSDraggingItem *dragItem = [[NSDraggingItem alloc] initWithPasteboardWriter:image];
        NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        
        dragItem.imageComponentsProvider = ^
        {
            NSDraggingImageComponent *imageComponent = [NSDraggingImageComponent draggingImageComponentWithKey:NSDraggingImageComponentIconKey];
            imageComponent.contents = image;
            
            imageComponent.frame = NSMakeRect(point.x - image.size.width / 2,
                                              point.y - image.size.height / 2,
                                              image.size.width,
                                              image.size.height);
            return @[imageComponent];
        };
        
        NSDraggingSession *session = [self beginDraggingSessionWithItems:@[dragItem] event:theEvent source:self];
        
        session.animatesToStartingPositionsOnCancelOrFail = YES;
        session.draggingFormation = NSDraggingFormationNone;
    }
    else
    {
        [super mouseDown:theEvent];
    }
}

- (NSInteger)row
{
    return [(NSTableView *)self.superview.superview.superview rowForView:self];
}

@end

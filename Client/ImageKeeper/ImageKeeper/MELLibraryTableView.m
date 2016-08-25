//
//  MELLibraryTableView.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/24/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELLibraryTableView.h"

@interface MELLibraryTableView() <NSDraggingSource>
@end

@implementation MELLibraryTableView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSInteger row = self.selectedRow;
    
    if (row >= 0)
    {
        NSImage *image = [self.imageLibraryPanelController imageAtIndex:row];

        NSDraggingItem *dragItem = [[NSDraggingItem alloc] initWithPasteboardWriter:image];
        NSPoint point = [NSEvent mouseLocation];
        
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


- (NSDragOperation)draggingSession:(NSDraggingSession *)aSession sourceOperationMaskForDraggingContext:(NSDraggingContext)aContext
{
    return NSDragOperationCopy;
}

@end

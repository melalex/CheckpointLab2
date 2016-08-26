//
//  MELImageView.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/25/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELImageView.h"
#import "MELNumber.h"

@interface MELImageView() <NSDraggingSource>
{
    NSTableView *_tableView;
}

@property (readonly) NSInteger row;
@property (readonly) NSTableView *tableView;
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

- (void)mouseDown:(NSEvent *)theEvent
{
    NSImage *image = self.image;
        
    if (image)
    {
        [self selectCurrentRow];
        
        NSDraggingItem *dragItem = [[NSDraggingItem alloc] initWithPasteboardWriter:[MELNumber numberWithItegerValue:self.row]];
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
        
        [dragItem release];
    }
    else
    {
        [super mouseDown:theEvent];
    }
}

- (void)selectCurrentRow
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:self.row];
    [self.tableView selectRowIndexes:indexSet byExtendingSelection:NO];
}

- (NSInteger)row
{
    return [self.tableView rowForView:self];
}

- (NSTableView *)tableView
{
    if (!_tableView)
    {
        _tableView = (NSTableView *)self.superview.superview.superview;
    }
    return _tableView;
}

@end

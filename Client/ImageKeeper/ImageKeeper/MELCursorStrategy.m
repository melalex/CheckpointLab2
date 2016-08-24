//
//  MELCursorStrategy.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/23/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MELCursorStrategy.h"
#import "MELDataStore.h"
#import "MELRect.h"
#import "MELElement.h"

@implementation MELCursorStrategy

- (void)mouseDownAction:(NSEvent *)theEvent
{
    NSPoint point = [self.ownerView convertPoint:[theEvent locationInWindow] fromView:nil];
    
    [self.dataStore selectElementInPoint:point];
}

#warning optimize deltaX, deltaY

- (void)mouseDraggAction:(NSEvent *)theEvent
{
    NSPoint point = [self.ownerView convertPoint:[theEvent locationInWindow] fromView:nil];
    NSRect selectedElementFrame = self.dataStore.selectedElement.frame.rect;
    
    if (NSPointInRect(point, selectedElementFrame))
    {
        self.dataStore.selectedElement.frame.x += theEvent.deltaX;
        self.dataStore.selectedElement.frame.y -= theEvent.deltaY;
    }
}

- (void)mouseUpAction:(NSEvent *)theEvent
{
    
}

@end

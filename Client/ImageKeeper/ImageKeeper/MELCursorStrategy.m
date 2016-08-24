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

@interface MELCursorStrategy()

@property NSPoint mouseOld;

@end

@implementation MELCursorStrategy

- (void)mouseDownAction:(NSEvent *)theEvent
{
    NSPoint point = [self.ownerView convertPoint:[theEvent locationInWindow] fromView:nil];
    
    [self.dataStore selectElementInPoint:point];
    
    self.mouseOld = point;
}

- (void)mouseDraggAction:(NSEvent *)theEvent
{
    NSPoint point = [self.ownerView convertPoint:[theEvent locationInWindow] fromView:nil];
    NSRect selectedElementFrame = [self.dataStore selectedElementFrame];
    
    if (NSPointInRect(point, selectedElementFrame))
    {
        CGFloat deltaX = self.mouseOld.x - point.x;
        CGFloat deltaY = self.mouseOld.y - point.y;

        self.dataStore.selectedElement.frame.x -= deltaX;
        self.dataStore.selectedElement.frame.y -= deltaY;
        
        self.mouseOld = point;
    }
}

- (void)mouseUpAction:(NSEvent *)theEvent
{
    
}

@end

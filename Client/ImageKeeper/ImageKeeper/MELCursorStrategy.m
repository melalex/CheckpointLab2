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
{
    MELDataStore *_dataStore;
    NSView *_ownerView;
}

@property CGFloat oldX;
@property CGFloat oldY;

@end

@implementation MELCursorStrategy

- (void)mouseDownAction:(NSEvent *)theEvent
{
    NSPoint point = [self.ownerView convertPoint:[theEvent locationInWindow] fromView:nil];
    
    [self.dataStore selectImageInPoint:point];
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

#pragma mark - MELCursorStrategySetters

- (void)setDataStore:(MELDataStore *)dataStore
{
    _dataStore = dataStore;
}

- (void)setOwnerView:(NSView *)ownerView
{
    _ownerView = ownerView;
}

#pragma mark - MELCursorStrategyGetters

- (MELDataStore *)dataStore
{
    return _dataStore;
}

- (NSView *)ownerView
{
    return _ownerView;
}

@end

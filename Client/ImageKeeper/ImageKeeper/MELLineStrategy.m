//
//  MELLineStrategy.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/23/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELLineStrategy.h"
#import "MELLineModel.h"
#import "MELRect.h"
#import "MELDataStore.h"

#import <Cocoa/Cocoa.h>

static CGFloat const kDefaultWidth = 20.0;
static CGFloat const kDefaultHeight = 20.0;

@interface MELLineStrategy()

@property (retain) MELLineModel *lineModel;

@end

@implementation MELLineStrategy

- (void)dealloc
{
    [_lineModel release];
    
    [super dealloc];
}

- (void)mouseDownAction:(NSEvent *)theEvent
{
    [self.dataStore deselectElement];
    
    NSPoint point = [self.ownerView convertPoint:[theEvent locationInWindow] fromView:nil];

    MELRect *defaultFrame = [[MELRect alloc] initWithX:point.x y:point.y width:kDefaultWidth height:kDefaultHeight];
    
    self.lineModel = [[[MELLineModel alloc] initWithFrame:defaultFrame layer:0] autorelease];
    self.lineModel.firstPoint = point;
    
    [self.dataStore putToDocumentModelElement:self.lineModel];
}

- (void)mouseDraggAction:(NSEvent *)theEvent
{
    NSPoint secondPoint = [self.ownerView convertPoint:[theEvent locationInWindow] fromView:nil];
    
    self.lineModel.secondPoint = secondPoint;
}

- (void)mouseUpAction:(NSEvent *)theEvent
{
    self.lineModel = nil;
}

@end

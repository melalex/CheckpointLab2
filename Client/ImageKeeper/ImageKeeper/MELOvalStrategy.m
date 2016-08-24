//
//  MELOvalStrategy.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/23/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELOvalStrategy.h"
#import "MELOvalModel.h"
#import "MELDataStore.h"
#import "MELRect.h"

#import <Cocoa/Cocoa.h>

static CGFloat const kDefaultWidth = 20.0;
static CGFloat const kDefaultHeight = 20.0;

@interface MELOvalStrategy()

@property (retain) MELOvalModel *ovalModel;
@property NSPoint firstPoint;

@end

@implementation MELOvalStrategy

- (void)dealloc
{
    [_ovalModel release];
    
    [super dealloc];
}

- (void)mouseDownAction:(NSEvent *)theEvent
{
    [self.dataStore deselectElement];
    
    NSPoint point = [self.ownerView convertPoint:[theEvent locationInWindow] fromView:nil];
    
    MELRect *defaultFrame = [[MELRect alloc] initWithX:point.x y:point.y width:kDefaultWidth height:kDefaultHeight];
    
    self.ovalModel = [[[MELOvalModel alloc] initWithFrame:defaultFrame layer:0] autorelease];
    self.firstPoint = point;

    [self.dataStore putToDocumentModelElement:self.ovalModel];
}

- (void)mouseDraggAction:(NSEvent *)theEvent
{
    NSPoint secondPoint = [self.ownerView convertPoint:[theEvent locationInWindow] fromView:nil];
    
    MELRect *ovalFrame = self.ovalModel.frame;
    
    ovalFrame.x = fmin(self.firstPoint.x, secondPoint.x);
    ovalFrame.y = fmin(self.firstPoint.y, secondPoint.y);
    ovalFrame.width = fabs(self.firstPoint.x - secondPoint.x);
    ovalFrame.height = fabs(self.firstPoint.y - secondPoint.y);
}

- (void)mouseUpAction:(NSEvent *)theEvent
{
    self.ovalModel = nil;
}

@end

//
//  MELPrimitiveStrategy.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/24/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELPrimitiveStrategy.h"
#import "MELDataStore.h"

#import <Cocoa/Cocoa.h>

@interface MELPrimitiveStrategy()
{
    id<MELCanvasModelController> _dataStore;
    NSView *_ownerView;
}

@end

@implementation MELPrimitiveStrategy

- (void)mouseDownAction:(NSEvent *)theEvent
{
    
}

- (void)mouseDraggAction:(NSEvent *)theEvent
{
    
}

- (void)mouseUpAction:(NSEvent *)theEvent
{
    
}

#pragma mark - MELPrimitiveStrategySetters

- (void)setDataStore:(id<MELCanvasModelController>)dataStore
{
    _dataStore = dataStore;
}

- (void)setOwnerView:(NSView *)ownerView
{
    _ownerView = ownerView;
}

#pragma mark - MELPrimitiveStrategyGetters

- (id<MELCanvasModelController>)dataStore
{
    return _dataStore;
}

- (NSView *)ownerView
{
    return _ownerView;
}


@end

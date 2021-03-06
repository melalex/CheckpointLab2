//
//  MELInstrumentPanelController.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/23/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELInstrumentPanelController.h"
#import "MELCursorStrategy.h"
#import "MELLineStrategy.h"
#import "MELOvalStrategy.h"
#import "MELRectangleStrategy.h"
#import "MELCurveStrategy.h"

@interface MELInstrumentPanelController ()
{
    id<MELChangeableStrategy> _canvasController;
    MELCursorStrategy *_cursorStrategy;
    MELLineStrategy *_lineStrategy;
    MELOvalStrategy *_ovalStrategy;
    MELRectangleStrategy *_rectangleStrategy;
    MELCurveStrategy *_curveStrategy;
}

@property (retain, readonly) MELCursorStrategy *cursorStrategy;
@property (retain, readonly) MELLineStrategy *lineStrategy;
@property (retain, readonly) MELOvalStrategy *ovalStrategy;
@property (retain, readonly) MELRectangleStrategy *rectangleStrategy;
@property (retain, readonly) MELCurveStrategy *curveStrategy;

@end

@implementation MELInstrumentPanelController

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)dealloc
{
    [_canvasController release];
    [_cursorStrategy release];
    [_lineStrategy release];

    [super dealloc];
}

- (IBAction)cursorSelected:(id)sender
{
    self.canvasController.strategy = self.cursorStrategy;
}

- (IBAction)lineSelected:(id)sender
{
    self.canvasController.strategy = self.lineStrategy;
}

- (IBAction)rectangleSelected:(id)sender
{
    self.canvasController.strategy = self.rectangleStrategy;
}

- (IBAction)ovalSelected:(id)sender
{
    self.canvasController.strategy = self.ovalStrategy;
}

- (IBAction)brushSelected:(id)sender
{
    self.canvasController.strategy = self.curveStrategy;
}

#pragma mark - MELCursorStrategySetters

- (void)setCanvasController:(id<MELChangeableStrategy>)canvasController
{
    if (_canvasController != canvasController)
    {
        [_canvasController release];
        _canvasController = [canvasController retain];
        
        _canvasController.strategy = self.cursorStrategy;
    }
}

#pragma mark - MELCursorStrategyGetters

- (id<MELChangeableStrategy>)canvasController
{
    return _canvasController;
}

- (MELCursorStrategy *)cursorStrategy
{
    if (!_cursorStrategy)
    {
        _cursorStrategy = [[MELCursorStrategy alloc] init];
    }
    return _cursorStrategy;
}

- (MELLineStrategy *)lineStrategy
{
    if (!_lineStrategy)
    {
        _lineStrategy = [[MELLineStrategy alloc] init];
    }
    return _lineStrategy;
}

- (MELOvalStrategy *)ovalStrategy
{
    if (!_ovalStrategy)
    {
        _ovalStrategy = [[MELOvalStrategy alloc] init];
    }
    return _ovalStrategy;
}

- (MELRectangleStrategy *)rectangleStrategy
{
    if (!_rectangleStrategy)
    {
        _rectangleStrategy = [[MELRectangleStrategy alloc] init];
    }
    return _rectangleStrategy;
}

- (MELCurveStrategy *)curveStrategy
{
    if (!_curveStrategy)
    {
        _curveStrategy = [[MELCurveStrategy alloc] init];
    }
    return _curveStrategy;
}

@end

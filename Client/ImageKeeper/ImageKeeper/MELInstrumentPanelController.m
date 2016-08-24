//
//  MELInstrumentPanelController.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/23/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELInstrumentPanelController.h"
#import "MELCanvasController.h"
#import "MELCursorStrategy.h"
#import "MELLineStrategy.h"

@interface MELInstrumentPanelController ()
{
    MELCanvasController *_canvasController;
    MELCursorStrategy *_cursorStrategy;
    MELLineStrategy *_lineStrategy;
}

@property (retain, readonly) MELCursorStrategy *cursorStrategy;
@property (retain, readonly) MELLineStrategy *lineStrategy;

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
    
}

- (IBAction)ovalSelected:(id)sender
{
    
}

- (IBAction)brushSelected:(id)sender
{
    
}

#pragma mark - MELCursorStrategySetters

- (void)setCanvasController:(MELCanvasController *)canvasController
{
    if (_canvasController != canvasController)
    {
        [_canvasController release];
        _canvasController = [canvasController retain];
        
        _canvasController.strategy = self.cursorStrategy;
    }
}

#pragma mark - MELCursorStrategyGetters

- (MELCanvasController *)canvasController
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

@end

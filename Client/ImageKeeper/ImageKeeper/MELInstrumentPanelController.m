//
//  MELInstrumentPanelController.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/23/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELInstrumentPanelController.h"
#import "MELCursorStrategy.h"
#import "MELCanvasController.h"

@interface MELInstrumentPanelController ()
{
    MELCanvasController *_canvasController;
    MELCursorStrategy *_cursorStrategy;
}

@property (retain, readonly) MELCursorStrategy *cursorStrategy;

@end

@implementation MELInstrumentPanelController

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)dealloc
{
    [_cursorStrategy release];
    [_canvasController release];
    
    [super dealloc];
}

- (void)setCanvasController:(MELCanvasController *)canvasController
{
    if (_canvasController != canvasController)
    {
        [_canvasController release];
        _canvasController = [canvasController retain];
        
        _canvasController.strategy = self.cursorStrategy;
    }
}

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

@end

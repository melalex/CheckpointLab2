//
//  MELCanvas.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MELImageModel;
@class MELCanvasController;

@interface MELCanvas : NSView<NSDraggingDestination>

@property (retain) NSArray<MELImageModel *> *imagesToDraw;
@property (assign) MELCanvasController *controller;

@end

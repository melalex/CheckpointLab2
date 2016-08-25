//
//  MELCanvas.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MELElement.h"

@class MELCanvasController;

@interface MELCanvas : NSView

@property (retain) NSArray<id<MELElement>> *elements;
@property (assign) MELCanvasController *controller;

@end

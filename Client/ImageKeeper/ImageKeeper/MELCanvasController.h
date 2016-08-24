//
//  MELCanvasController.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MELStrategy.h"
#import "MELElement.h"
#import "MELDataStoreProtocols.h"

@class MELCanvas;

@interface MELCanvasController : NSViewController

@property (retain) id<MELStrategy> strategy;
@property (retain) NSObject<MELCanvasModelController> *dataStore;
@property (readonly) MELCanvas *canvas;

- (void)addImageFromLibraryAtIndex:(NSUInteger)index toPoint:(NSPoint)point;

- (BOOL)isSelected:(id<MELElement>)element;

- (void)copySelectedImage;
- (void)paste;
- (void)deleteSelectedImage;

@end

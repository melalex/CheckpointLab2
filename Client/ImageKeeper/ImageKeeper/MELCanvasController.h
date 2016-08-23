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

@class MELDataStore;
@class MELCanvas;

@interface MELCanvasController : NSViewController

@property (retain) id<MELStrategy> strategy;
@property (retain) MELDataStore *dataStore;
@property (readonly) MELCanvas *canvas;

- (void)addImageFromLibraryAtIndex:(NSUInteger)index toPoint:(NSPoint)point;

- (BOOL)isSelected:(id<MELElement>)element;
- (NSRect)selectedImageFrame;

- (void)copySelectedImage;
- (void)paste;
- (void)deleteSelectedImage;

@end

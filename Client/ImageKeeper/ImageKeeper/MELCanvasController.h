//
//  MELCanvasController.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MELDataStore;
@class MELCanvas;
@class MELImageModel;

@interface MELCanvasController : NSViewController

@property (retain) MELDataStore *dataStore;
@property (readonly) MELCanvas *canvas;

- (void)addImageFromLibraryAtIndex:(NSUInteger)index toPoint:(NSPoint)point;

- (void)selectImageInPoint:(NSPoint)point;
#warning imageAtIndex
- (NSImage *)imageAtIndex:(NSUInteger)index;

- (void)shiftByDeltaX:(CGFloat)deltaX deltaY:(CGFloat)deltaY;
- (BOOL)isSelected:(MELImageModel *)image;
- (NSRect)selectedImageFrame;

- (void)copySelectedImage;
- (void)paste;
- (void)deleteSelectedImage;

@end

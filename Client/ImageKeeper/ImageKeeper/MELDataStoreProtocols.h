//
//  MELDataStoreProtocols.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/24/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MELElement.h"

@class MELRect;
@class MELDocumentModel;

@protocol MELImageLibraryPanelModelController <NSObject>

@property (readonly, retain) NSArray<NSImage *> *images;

- (void)removeImage:(NSImage *)image;
- (NSArray<NSImage *> *)images;
- (NSUInteger)countOfImages;
- (id)objectInImagesAtIndex:(NSUInteger)index;
- (void)insertObject:(NSImage *)object inImagesAtIndex:(NSUInteger)index;
- (void)removeObjectFromImagesAtIndex:(NSUInteger)index;

- (void)putToDocumentModelImage:(NSImage *)image inFrame:(MELRect *)frame;

@end

@protocol MELCanvasModelController <NSObject>

@property (retain) MELDocumentModel *documentModel;
@property (readonly, assign) id<MELElement> selectedElement;

- (void)putToDocumentModelImageFromLibraryAtIndex:(NSUInteger)index toPoint:(NSPoint)point;
- (void)putToDocumentModelImage:(NSImage *)image inFrame:(MELRect *)frame;

- (void)selectElementInPoint:(NSPoint)point;
- (void)shiftSelectedElementByDeltaX:(CGFloat)deltaX deltaY:(CGFloat)deltaY;
- (BOOL)isSelected:(id<MELElement>)element;
- (NSRect)selectedElementFrame;
- (void)deselectElement;

- (void)putToDocumentModelElement:(id<MELElement>)element;

@end

@protocol MELImageInspectorModelController <NSObject>

@property (readonly, assign) id<MELElement> selectedElement;

- (NSArray<id<MELElement>> *)getElements;

@end

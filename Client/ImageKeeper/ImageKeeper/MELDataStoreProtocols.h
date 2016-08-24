//
//  MELDataStoreProtocols.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/24/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MELElement.h"

//@property (retain) MELDocumentModel *documentModel;
//@property (readonly, retain) NSArray<NSImage *> *images;
//@property (readonly, assign) id<MELElement> selectedElement;
//
//- (void)setDocumentModel:(MELDocumentModel *)documentModel;
//
//- (void)putToDocumentModelImage:(NSImage *)image inFrame:(MELRect *)frame;
//- (void)putToDocumentModelElement:(id<MELElement>)element;
//
//- (void)selectElementInPoint:(NSPoint)point;
//- (void)deselectElement;
//
//- (void)addImage:(NSImage *)image;
//- (void)removeImage:(NSImage *)image;
//

@class MELRect;
@class MELDocumentModel;

@protocol MELImageLibraryPanelModelController <NSObject>

@property (readonly, retain) NSArray<NSImage *> *images;

- (void)addImage:(NSImage *)image;
- (void)removeImage:(NSImage *)image;

- (void)putToDocumentModelImage:(NSImage *)image inFrame:(MELRect *)frame;

@end

@protocol MELCanvasModelController <NSObject>

@property (retain) MELDocumentModel *documentModel;
@property (readonly, assign) id<MELElement> selectedElement;

- (void)putToDocumentModelImageFromLibraryAtIndex:(NSUInteger)index toPoint:(NSPoint)point;

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

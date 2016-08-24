//
//  MELDataStore.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MELElement.h"

@class MELDocumentModel;
@class MELRect;

#warning Add protocols

@interface MELDataStore : NSObject

@property (retain) MELDocumentModel *documentModel;
@property (readonly, retain) NSArray<NSImage *> *images;
@property (readonly, assign) id<MELElement> selectedElement;

- (void)setDocumentModel:(MELDocumentModel *)documentModel;

- (void)putToDocumentModelImage:(NSImage *)image inFrame:(MELRect *)frame;
- (void)putToDocumentModelElement:(id<MELElement>)element;

- (void)selectElementInPoint:(NSPoint)point;
- (void)deselectElement;

- (void)addImage:(NSImage *)image;
- (void)removeImage:(NSImage *)image;

@end

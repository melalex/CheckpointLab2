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

@property (readonly, retain) NSArray<NSImage *> *images;
@property (retain) MELDocumentModel *documentModel;
@property (readonly, assign) id<MELElement> selectedElement;

- (void)putToDocumentModelImage:(NSImage *)image inFrame:(MELRect *)frame;
- (void)putToDocumentModelElement:(id<MELElement>)element;

- (void)selectImageInPoint:(NSPoint)point;
- (void)deselectImage;

- (void)addImage:(NSImage *)image;
- (void)removeImage:(NSImage *)image;

@end

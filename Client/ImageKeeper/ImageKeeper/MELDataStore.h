//
//  MELDataStore.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MELDocumentModel;
@class MELImageModel;
@class MELRect;

@interface MELDataStore : NSObject

@property (readonly, retain) NSArray<NSImage *> *images;
@property (retain) MELDocumentModel *documentModel;
@property (readonly, assign) MELImageModel *selectedImage;

- (void)putToDocumentModelImage:(NSImage *)image inFrame:(MELRect *)frame;
- (void)putToDocumentModelImageModel:(MELImageModel *)imageModel;

- (void)selectImageInPoint:(NSPoint)point;

- (void)addImage:(NSImage *)image;
- (void)removeImage:(NSImage *)image;

@end

//
//  MELDocumentModel.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MELImageModel;
@class MELRect;

@interface MELDocumentModel : NSObject

@property (retain, readonly) NSArray<MELImageModel *> *imagesToDraw;

- (void)addImagesToDrawObject:(MELImageModel *)object;
- (void)removeImage:(MELImageModel *)image;

- (NSUInteger)currentLayerInRect:(MELRect *)rect;
- (MELImageModel *)takeTopImageInPoint:(NSPoint)point;

@end

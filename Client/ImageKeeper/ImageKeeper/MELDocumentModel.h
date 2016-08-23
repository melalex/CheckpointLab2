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

#warning encapsulate
@property (retain, readonly) NSArray<MELImageModel *> *imagesToDraw;

- (void)addImage:(MELImageModel *)image;
- (void)removeImage:(MELImageModel *)image;

#warning Вызов метода addImagesToDrawObject возбуждает исключение '*** -[NSSet intersectsSet:]: set argument is not an NSSet'
- (void)addImagesToDrawObject:(MELImageModel *)object;
#warning Вызов метода removeImagesToDrawObject возбуждает исключение '*** -[NSSet intersectsSet:]: set argument is not an NSSet'
- (void)removeImagesToDrawObject:(MELImageModel *)object;

- (MELImageModel *)takeTopImageInPoint:(NSPoint)point;

@end

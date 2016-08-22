//
//  MELDocumentModel.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELDocumentModel.h"
#import "MELImageModel.h"
#import "MELRect.h"

@interface MELDocumentModel()

@property NSMutableArray<MELImageModel *> *mutableImagesToDraw;

@end

@implementation MELDocumentModel

- (instancetype)init
{
    if (self = [super init])
    {
        _mutableImagesToDraw = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_mutableImagesToDraw release];
    
    [super dealloc];
}

- (NSUInteger)currentLayerInRect:(MELRect *)rect
{
    NSUInteger result = 0;
    NSRect rectangle = rect.rect;
    
    for (MELImageModel *imageModel in self.imagesToDraw)
    {
        NSRect imageModelRect = imageModel.frame.rect;

        if (!(NSMaxY(rectangle) < NSMinY(imageModelRect) ||
              NSMinY(rectangle) > NSMaxY(imageModelRect) ||
              NSMaxX(rectangle) < NSMinX(imageModelRect) ||
              NSMinX(rectangle) > NSMaxX(imageModelRect)))
        {
            result++;
        }
    }
    
    return result;
}

- (MELImageModel *)takeTopImageInPoint:(NSPoint)point
{
    MELImageModel *result = nil;
    NSUInteger topLayer = 0;
    
    for (MELImageModel *imageModel in self.mutableImagesToDraw)
    {
        NSRect imageModelRect = imageModel.frame.rect;
        
        if (NSMaxX(imageModelRect) > point.x &&
            NSMinX(imageModelRect) < point.x &&
            NSMaxY(imageModelRect) > point.y &&
            NSMinY(imageModelRect) < point.y &&
            imageModel.layer > topLayer)
        {
            
            result = imageModel;
            topLayer = imageModel.layer;
        }
    }
    
    return result;
}

- (void)removeImage:(MELImageModel *)image
{
    [self removeImage:image];
}

#pragma mark - MELDocumentModel KVC Support

- (void)addImagesToDrawObject:(MELImageModel *)object
{
    [self insertObject:object inImagesToDrawAtIndex:[self.mutableImagesToDraw count]];
}

- (NSArray<MELImageModel *> *)imagesToDraw
{
    return [[(NSArray<MELImageModel *> *)self.mutableImagesToDraw copy] autorelease];
}

- (NSUInteger)countOfImagesToDraw
{
    return self.mutableImagesToDraw.count;
}

- (MELImageModel *)objectInImagesToDrawAtIndex:(NSUInteger)index
{
    return self.mutableImagesToDraw[index];
}

- (void)insertObject:(MELImageModel *)object inImagesToDrawAtIndex:(NSUInteger)index
{
    [self.mutableImagesToDraw insertObject:object atIndex:index];
}

- (void)removeObjectFromImagesToDrawAtIndex:(NSUInteger)index
{
    [self.mutableImagesToDraw removeObjectAtIndex:index];
}

@end

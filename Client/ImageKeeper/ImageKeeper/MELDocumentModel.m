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

#pragma mark - Work with layers

- (MELImageModel *)takeTopImageInPoint:(NSPoint)point
{
    MELImageModel *result = nil;
    NSUInteger topLayer = 0;
    
    for (MELImageModel *imageModel in self.mutableImagesToDraw)
    {
        NSRect imageModelRect = imageModel.frame.rect;
        
        if (NSPointInRect(point, imageModelRect) &&
            imageModel.layer > topLayer)
        {
            result = imageModel;
            topLayer = imageModel.layer;
        }
    }
    
    return result;
}

#warning решить судьбу методов

//- (BOOL)doIntersectRectA:(NSRect)rectA withRectB:(NSRect)rectB
//{
//    return !(NSMaxY(rectA) < NSMinY(rectB) ||
//             NSMinY(rectA) > NSMaxY(rectB) ||
//             NSMaxX(rectA) < NSMinX(rectB) ||
//             NSMinX(rectA) > NSMaxX(rectB));
//}

//- (NSUInteger)takeTopLayerOfImages:(NSArray<MELImageModel *> *)images
//{
//    NSUInteger topLayer = 0;
//    
//    for (MELImageModel *image in images)
//    {
//        if (image.layer > topLayer)
//        {
//            topLayer = image.layer;
//        }
//    }
//    
//    return topLayer;
//}

//- (NSArray<MELImageModel *> *)imagesInRect:(NSRect)rect
//{
//    NSMutableArray<MELImageModel *> *images = [NSMutableArray array];
//    
//    for (MELImageModel *imageModel in self.mutableImagesToDraw)
//    {
//        NSRect imageModelRect = imageModel.frame.rect;
//        
//        if ([self doIntersectRectA:rect withRectB:imageModelRect])
//        {
//            [images addObject:imageModel];
//        }
//    }
//
//    return [[images copy] autorelease];
//}

#pragma mark - MELDocumentModel KVC Support

- (void)addImage:(MELImageModel *)image
{
    [self insertObject:image inImagesToDrawAtIndex:self.mutableImagesToDraw.count];
}

- (void)addImagesToDrawObject:(MELImageModel *)object
{
    [self.mutableImagesToDraw addObject:object];
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

- (void)removeImagesToDrawObject:(MELImageModel *)object;
{
    [self.mutableImagesToDraw removeObject:object];
}

@end

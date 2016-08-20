//
//  MELDocumentModel.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELDocumentModel.h"
#import "MELImageModel.h"

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

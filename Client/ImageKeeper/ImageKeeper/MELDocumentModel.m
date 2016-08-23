//
//  MELDocumentModel.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELDocumentModel.h"
#import "MELRect.h"

@interface MELDocumentModel()

@property NSMutableArray<id<MELElement>> *mutableElements;

@end

@implementation MELDocumentModel

- (instancetype)init
{
    if (self = [super init])
    {
        _mutableElements = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_mutableElements release];
    
    [super dealloc];
}

#pragma mark - Work with layers

- (id<MELElement>)takeTopElementInPoint:(NSPoint)point;
{
    id<MELElement> result = nil;
    NSUInteger topLayer = 0;
    
    for (id<MELElement> element in self.mutableElements)
    {
        NSRect elementModelRect = element.frame.rect;
        
        if (NSPointInRect(point, elementModelRect) &&
            element.layer > topLayer)
        {
            result = element;
            topLayer = element.layer;
        }
    }
    
    return result;
}

#pragma mark - MELDocumentModel KVC Support

- (void)addElement:(id<MELElement>)element;
{
    if (element)
    {
        [self insertObject:element inElementsAtIndex:self.mutableElements.count];
    }
}

- (void)removeElement:(id<MELElement>)element;
{
    for (id<MELElement> element in self.mutableElements)
    {
        if (element.layer < element.layer)
        {
            element.layer--;
        }
    }
    
    [self removeObjectFromElementsAtIndex:[self.mutableElements indexOfObject:element]];
}

- (NSArray<id<MELElement>> *)elements
{
    [self.mutableElements sortUsingComparator:^NSComparisonResult(id<MELElement> a, id<MELElement> b)
     {
         return (NSComparisonResult)(a.layer > b.layer);
     }];

    return [[(NSArray<id<MELElement>> *)self.mutableElements copy] autorelease];
}

- (NSUInteger)countOfElements
{
    return self.mutableElements.count;
}

- (id)objectInElementsAtIndex:(NSUInteger)index
{
    return self.mutableElements[index];
}

- (void)insertObject:(id<MELElement>)object inElementsAtIndex:(NSUInteger)index
{
    if (object)
    {
        [self.mutableElements insertObject:object atIndex:index];
    }
}

- (void)removeObjectFromElementsAtIndex:(NSUInteger)index
{
    [self.mutableElements removeObjectAtIndex:index];
}

@end

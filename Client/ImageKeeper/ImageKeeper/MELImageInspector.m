//
//  MELImageInspector.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/21/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELImageInspector.h"
#import "MELDataStore.h"
#import "Macros.h"
#import "MELRect.h"
#import "MELDocumentModel.h"
#import "MELElement.h"

@interface MELImageInspector ()

@end

@implementation MELImageInspector

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)dealloc
{
    [_dataStore release];
    
    [super dealloc];
}

#pragma mark MELImageInspector Bindings Support

+ (NSSet *)keyPathsForValuesAffectingXCoordinate
{
    return [NSSet setWithObjects:@TYPE_KEY_PATH(MELImageInspector, dataStore.selectedElement.frame.x), nil];
}

+ (NSSet *)keyPathsForValuesAffectingYCoordinate
{
    return [NSSet setWithObjects:@TYPE_KEY_PATH(MELImageInspector, dataStore.selectedElement.frame.y), nil];
}

+ (NSSet *)keyPathsForValuesAffectingWidth
{
    return [NSSet setWithObjects:@TYPE_KEY_PATH(MELImageInspector, dataStore.selectedElement.frame.width), nil];
}

+ (NSSet *)keyPathsForValuesAffectingHeight
{
    return [NSSet setWithObjects:@TYPE_KEY_PATH(MELImageInspector, dataStore.selectedElement.frame.height), nil];
}

+ (NSSet *)keyPathsForValuesAffectingLayer
{
    return [NSSet setWithObjects:@TYPE_KEY_PATH(MELImageInspector, dataStore.selectedElement.layer), nil];
}

+ (NSSet *)keyPathsForValuesAffectingIsSelected
{
    return [NSSet setWithObjects:@TYPE_KEY_PATH(MELImageInspector, dataStore.selectedElement), nil];
}

#pragma mark - MELImageInspectorSetters

- (void)setXCoordinate:(CGFloat)xCoordinate
{
    self.dataStore.selectedElement.frame.x = xCoordinate;
}

- (void)setYCoordinate:(CGFloat)yCoordinate
{
    self.dataStore.selectedElement.frame.y = yCoordinate;
}

- (void)setWidth:(CGFloat)width
{
    self.dataStore.selectedElement.frame.width = width;
}

- (void)setHeight:(CGFloat)height
{
    self.dataStore.selectedElement.frame.height = height;
}

- (void)setLayer:(NSUInteger)layer
{
    NSUInteger oldLayer = self.dataStore.selectedElement.layer;
    
    for (id<MELElement> element in self.dataStore.documentModel.elements)
    {
        if (element.layer > oldLayer)
        {
            element.layer--;
        }
        
        if (element.layer >= layer)
        {
            element.layer++;
        }
    }

    self.dataStore.selectedElement.layer = layer;
}

#pragma mark - MELImageInspectorGetters

- (CGFloat)xCoordinate
{
    return self.dataStore.selectedElement.frame.x;
}

- (CGFloat)yCoordinate
{
    return self.dataStore.selectedElement.frame.y;
}

- (CGFloat)width
{
    return self.dataStore.selectedElement.frame.width;
}

- (CGFloat)height
{
    return self.dataStore.selectedElement.frame.height;
}

- (NSUInteger)layer
{
    return self.dataStore.selectedElement.layer;
}

- (BOOL)isSelected
{
    BOOL result = NO;
    
    if (self.dataStore.selectedElement)
    {
        result = YES;
    }
    
    return  result;
}
@end

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
#import "MELImageModel.h"
#import "MELRect.h"
#import "MELDocumentModel.h"

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
    return [NSSet setWithObjects:@TYPE_KEY_PATH(MELImageInspector, dataStore.selectedImage.frame.x), nil];
}

+ (NSSet *)keyPathsForValuesAffectingYCoordinate
{
    return [NSSet setWithObjects:@TYPE_KEY_PATH(MELImageInspector, dataStore.selectedImage.frame.y), nil];
}

+ (NSSet *)keyPathsForValuesAffectingWidth
{
    return [NSSet setWithObjects:@TYPE_KEY_PATH(MELImageInspector, dataStore.selectedImage.frame.width), nil];
}

+ (NSSet *)keyPathsForValuesAffectingHeight
{
    return [NSSet setWithObjects:@TYPE_KEY_PATH(MELImageInspector, dataStore.selectedImage.frame.height), nil];
}

+ (NSSet *)keyPathsForValuesAffectingLayer
{
    return [NSSet setWithObjects:@TYPE_KEY_PATH(MELImageInspector, dataStore.selectedImage.layer), nil];
}

+ (NSSet *)keyPathsForValuesAffectingIsSelected
{
    return [NSSet setWithObjects:@TYPE_KEY_PATH(MELImageInspector, dataStore.selectedImage), nil];
}

#pragma mark - MELImageInspectorSetters

- (void)setXCoordinate:(CGFloat)xCoordinate
{
    self.dataStore.selectedImage.frame.x = xCoordinate;
}

- (void)setYCoordinate:(CGFloat)yCoordinate
{
    self.dataStore.selectedImage.frame.y = yCoordinate;
}

- (void)setWidth:(CGFloat)width
{
    self.dataStore.selectedImage.frame.width = width;
}

- (void)setHeight:(CGFloat)height
{
    self.dataStore.selectedImage.frame.height = height;
}

- (void)setLayer:(NSUInteger)layer
{
    NSUInteger oldLayer = self.dataStore.selectedImage.layer;
    
    for (MELImageModel *image in self.dataStore.documentModel.imagesToDraw)
    {
        if (image.layer > oldLayer)
        {
            image.layer--;
        }
        
        if (image.layer >= layer)
        {
            image.layer++;
        }
    }

    self.dataStore.selectedImage.layer = layer;
}

#pragma mark - MELImageInspectorGetters

- (CGFloat)xCoordinate
{
    return self.dataStore.selectedImage.frame.x;
}

- (CGFloat)yCoordinate
{
    return self.dataStore.selectedImage.frame.y;
}

- (CGFloat)width
{
    return self.dataStore.selectedImage.frame.width;
}

- (CGFloat)height
{
    return self.dataStore.selectedImage.frame.height;
}

- (NSUInteger)layer
{
    return self.dataStore.selectedImage.layer;
}

- (BOOL)isSelected
{
    BOOL result = NO;
    
    if (self.dataStore.selectedImage)
    {
        result = YES;
    }
    
    return  result;
}
@end

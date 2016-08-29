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
#import "MELPrimitiveModel.h"

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

#pragma mark - ui events


#warning warning

- (IBAction)thicknessChanged:(NSPopUpButton *)sender
{
    MELPrimitiveModel *selectedElement = (MELPrimitiveModel *)self.dataStore.selectedElement;
    CGFloat newThickness = sender.indexOfSelectedItem + 1;
    
    selectedElement.thickness = newThickness;
}

- (IBAction)colorChanged:(NSColorWell *)sender
{
    MELPrimitiveModel *selectedElement = (MELPrimitiveModel *)self.dataStore.selectedElement;

    selectedElement.color = sender.color;
}

- (IBAction)rotationChanged:(NSSlider *)sender
{
//    self.dataStore.selectedElement.rotation = M_PI * sender.floatValue / 50.0;
}

- (IBAction)transparencyChanged:(NSSlider *)sender
{
//    self.dataStore.selectedElement.transparency = 1.0 - sender.floatValue / 100.0;
}

#pragma mark - MELImageInspector Bindings Support

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

+ (NSSet *)keyPathsForValuesAffectingIsFigure
{
    return [NSSet setWithObjects:@TYPE_KEY_PATH(MELImageInspector, dataStore.selectedElement), nil];
}

//+ (NSSet *)keyPathsForValuesAffectingThickness
//{
//    return [NSSet setWithObjects:@"dataStore.selectedElement.thickness", nil];
//}

+ (NSSet *)keyPathsForValuesAffectingRotation
{
    return [NSSet setWithObjects:@TYPE_KEY_PATH(MELImageInspector, dataStore.selectedElement.rotation), nil];
}

+ (NSSet *)keyPathsForValuesAffectingTransparency
{
    return [NSSet setWithObjects:@TYPE_KEY_PATH(MELImageInspector, dataStore.selectedElement.transparency), nil];
}

//+ (NSSet *)keyPathsForValuesAffectingColor
//{
//    return [NSSet setWithObjects:@"dataStore.selectedElement.color", nil];
//}

#pragma mark - MELImageInspectorSetters

- (void)setXCoordinate:(CGFloat)xCoordinate
{
    [[self.dataStore.undoManager prepareWithInvocationTarget:self] setXCoordinate:self.dataStore.selectedElement.frame.x];

    self.dataStore.selectedElement.frame.x = xCoordinate;
}

- (void)setYCoordinate:(CGFloat)yCoordinate
{
    [[self.dataStore.undoManager prepareWithInvocationTarget:self] setYCoordinate:self.dataStore.selectedElement.frame.y];

    self.dataStore.selectedElement.frame.y = yCoordinate;
}

- (void)setWidth:(CGFloat)width
{
    [[self.dataStore.undoManager prepareWithInvocationTarget:self] setWidth:self.dataStore.selectedElement.frame.width];

    self.dataStore.selectedElement.frame.width = width;
}

- (void)setHeight:(CGFloat)height
{
    [[self.dataStore.undoManager prepareWithInvocationTarget:self] setHeight:self.dataStore.selectedElement.frame.height];

    self.dataStore.selectedElement.frame.height = height;
}

- (void)setLayer:(NSUInteger)layer
{
    NSUInteger oldLayer = self.dataStore.selectedElement.layer;
    NSArray<id<MELElement>> *elements = [self.dataStore getElements];
    
    for (id<MELElement> element in elements)
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
    
    [[self.dataStore.undoManager prepareWithInvocationTarget:self] setLayer:oldLayer];
}

- (void)setThickness:(CGFloat)thickness
{
    MELPrimitiveModel *selectedElement = (MELPrimitiveModel *)self.dataStore.selectedElement;
    
    selectedElement.thickness = thickness + 1;
}

- (void)setRotation:(CGFloat)rotation
{
    CGFloat newRotation = M_PI * rotation / 50.0;
    
    self.dataStore.selectedElement.rotation = newRotation;
}

- (void)setTransparency:(CGFloat)transparency
{
    CGFloat newTransparency = 1.0 - transparency / 100.0;

    self.dataStore.selectedElement.transparency = newTransparency;
}

- (void)setColor:(NSColor *)color
{
    MELPrimitiveModel *selectedElement = (MELPrimitiveModel *)self.dataStore.selectedElement;
    
    selectedElement.color = color;
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
    return self.dataStore.selectedElement != nil;
}

- (BOOL)isFigure
{
    return [self.dataStore.selectedElement isKindOfClass:[MELPrimitiveModel class]];
}

- (CGFloat)thickness
{
    MELPrimitiveModel *selectedElement = (MELPrimitiveModel *)self.dataStore.selectedElement;
    
    return selectedElement.thickness - 1;
}

- (CGFloat)rotation
{
    CGFloat floatValue = self.dataStore.selectedElement.rotation * 50.0 / M_PI;

    return floatValue;
}

- (CGFloat)transparency
{
    CGFloat floatValue = (1.0 - self.dataStore.selectedElement.transparency) * 100.0;

    return floatValue;
}

- (NSColor *)color
{
    MELPrimitiveModel *selectedElement = (MELPrimitiveModel *)self.dataStore.selectedElement;
    
    return selectedElement.color;
}

@end

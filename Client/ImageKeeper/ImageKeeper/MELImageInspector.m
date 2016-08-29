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

@property (assign) IBOutlet NSPopUpButton *thicknessPopUp;
@property (assign) IBOutlet NSColorWell *colorWell;

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


- (IBAction)thicknessChanged:(NSPopUpButton *)sender
{
    MELPrimitiveModel *selectedElement = (MELPrimitiveModel *)self.dataStore.selectedElement;

    [[self.dataStore.undoManager prepareWithInvocationTarget:selectedElement] setThickness:selectedElement.thickness];

    CGFloat newThickness = sender.indexOfSelectedItem + 1;
    
    selectedElement.thickness = newThickness;
}

- (IBAction)colorChanged:(NSColorWell *)sender
{
    MELPrimitiveModel *selectedElement = (MELPrimitiveModel *)self.dataStore.selectedElement;

    [self.dataStore.undoManager registerUndoWithTarget:selectedElement
                               selector:@selector(setColor:)
                                 object:selectedElement.color];
    
    selectedElement.color = sender.color;
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

+ (NSSet *)keyPathsForValuesAffectingElementLayer
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

+ (NSSet *)keyPathsForValuesAffectingRotation
{
    return [NSSet setWithObjects:@TYPE_KEY_PATH(MELImageInspector, dataStore.selectedElement.rotation), nil];
}

+ (NSSet *)keyPathsForValuesAffectingTransparency
{
    return [NSSet setWithObjects:@TYPE_KEY_PATH(MELImageInspector, dataStore.selectedElement.transparency), nil];
}

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

- (void)setElementLayer:(NSUInteger)elementLayer
{
    NSUInteger oldLayer = self.dataStore.selectedElement.layer;
    NSArray<id<MELElement>> *elements = [self.dataStore getElements];
    
    for (id<MELElement> element in elements)
    {
        if (element.layer > oldLayer)
        {
            element.layer--;
        }
        
        if (element.layer >= elementLayer)
        {
            element.layer++;
        }
    }

    self.dataStore.selectedElement.layer = elementLayer;
    
    [[self.dataStore.undoManager prepareWithInvocationTarget:self] setElementLayer:oldLayer];
}

- (void)setRotation:(CGFloat)rotation
{
    [[self.dataStore.undoManager prepareWithInvocationTarget:self] setRotation:self.dataStore.selectedElement.rotation];

    CGFloat newRotation = M_PI * rotation / 50.0;
    
    self.dataStore.selectedElement.rotation = newRotation;
}

- (void)setTransparency:(CGFloat)transparency
{
    [[self.dataStore.undoManager prepareWithInvocationTarget:self] setTransparency:self.dataStore.selectedElement.transparency];

    CGFloat newTransparency = 1.0 - transparency / 100.0;

    self.dataStore.selectedElement.transparency = newTransparency;
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

- (NSUInteger)elementLayer
{
    return self.dataStore.selectedElement.layer;
}

- (BOOL)isSelected
{
    return self.dataStore.selectedElement != nil;
}

- (BOOL)isFigure
{
    BOOL result = [self.dataStore.selectedElement isKindOfClass:[MELPrimitiveModel class]];
    
    if (result)
    {
        MELPrimitiveModel *selectedElement = (MELPrimitiveModel *)self.dataStore.selectedElement;

        self.colorWell.color = selectedElement.color;
        [self.thicknessPopUp selectItemAtIndex:(selectedElement.thickness - 1)];
    }
    
    return result;
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

@end

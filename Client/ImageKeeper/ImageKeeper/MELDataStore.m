//
//  MELDataStore.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MELDataStore.h"
#import "MELDocumentModel.h"
#import "MELImageModel.h"
#import "MELRect.h"

static NSString *const kLproj = @"lproj";
static NSString *const kNib = @"nib";

@interface MELDataStore()

@property (retain) NSMutableArray<NSImage *> *mutableImages;
@property (assign) id<MELElement> selectedElement;

@end

@implementation MELDataStore

- (instancetype)init
{
    if (self = [super init])
    {
        _mutableImages = [[NSMutableArray alloc] init];
        
        NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:nil inDirectory:nil];
        
        for (NSString *path in paths)
        {
            if (![path hasSuffix:kLproj] && ![path hasSuffix:kNib])
            {
                NSURL *imageURL = [NSURL fileURLWithPath:path];
                NSString *imageName = [[[imageURL pathComponents] lastObject] componentsSeparatedByString:@"."][0];
                
                if (![imageName hasPrefix:@"__Interface__"])
                {
                    NSImage *imageObj = [[NSImage alloc] initWithContentsOfURL:imageURL];
                    
                    imageObj.name = imageName;
                    
                    [_mutableImages addObject:imageObj];
                    
                    [imageObj release];
                }
            }
        }
    }
    return self;
}

- (void)dealloc
{
    [_mutableImages release];
    
    [super dealloc];
}

- (void)selectElementInPoint:(NSPoint)point
{
    self.selectedElement = [self.documentModel takeTopElementInPoint:point];
}

- (void)shiftSelectedElementByDeltaX:(CGFloat)deltaX deltaY:(CGFloat)deltaY
{
    self.selectedElement.frame.x += deltaX;
    self.selectedElement.frame.y -= deltaY;
}

- (NSRect)selectedElementFrame
{
    return self.selectedElement.frame.rect;
}

- (void)deselectElement
{
    self.selectedElement = nil;
}

- (void)addImage:(NSImage *)image
{
    
}

- (void)removeImage:(NSImage *)image
{
    
}

- (BOOL)isSelected:(id<MELElement>)element
{
    BOOL result = NO;
    
    if (element == self.selectedElement)
    {
        result = YES;
    }
    
    return result;
}

- (NSArray<id<MELElement>> *)getElements
{
    return self.documentModel.elements;
}

#pragma mark - MELDocumentModel modification

#warning optimize layer

- (void)putToDocumentModelImageFromLibraryAtIndex:(NSUInteger)index toPoint:(NSPoint)point;
{
    NSImage *image = self.images[index];
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat x = point.x - image.size.width / 2;
    CGFloat y = point.y - image.size.height / 2;
    
    MELRect *frame = [[MELRect alloc] initWithX:x y:y width:width height:height];
    
    [self putToDocumentModelImage:image inFrame:frame];
}

- (void)putToDocumentModelImage:(NSImage *)image inFrame:(MELRect *)frame
{
    NSUInteger layer = self.documentModel.elements.count + 1;
    
    [self.documentModel addElement:[[MELImageModel alloc] initWithImage:image frame:frame layer:layer]];
}

- (void)putToDocumentModelElement:(id<MELElement>)element;
{
    element.layer = self.documentModel.elements.count + 1;
    
    [self.documentModel addElement:element];
}

#pragma mark - MELDataStoreGetters

- (NSArray<NSImage *> *)images
{
    return [[(NSArray<NSImage *> *)self.mutableImages copy] autorelease];
}

@end

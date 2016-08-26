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

static NSString *const kDefaultFileName = @"New Image";
static NSString *const kDefaultImages = @"DefaultImages";
static NSString *const kProductName = @"ImageKeeper";

@interface MELDataStore()
{
    NSString *_pathToImageKeeperSupportDirectory;
}

@property (retain) NSMutableArray<NSImage *> *mutableImages;
@property (retain) NSArray<NSImage *> *defaultImages;

@property (assign) id<MELElement> selectedElement;

@property (readonly, retain) NSString *pathToImageKeeperSupportDirectory;

@end

@implementation MELDataStore

- (instancetype)init
{
    if (self = [super init])
    {
        _mutableImages = [[NSMutableArray alloc] init];
        
        NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:nil inDirectory:kDefaultImages];
        
        for (NSString *path in paths)
        {
            [self uploadImageForPath:path];
        }
        
        _defaultImages = [[NSArray alloc] initWithArray:_mutableImages];
        
        NSString *pathToImageKeeperSupportDirectory = [self pathToImageKeeperSupportDirectory];
        
        NSError *error = nil;
        paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathToImageKeeperSupportDirectory
                                                                    error:&error];
        
        if (error)
        {
            NSLog(@"error taking content: %@", [error localizedDescription]);
        }
        
        for (NSString *path in paths)
        {
            [self uploadImageForPath:[pathToImageKeeperSupportDirectory stringByAppendingPathComponent:path]];
        }

    }
    return self;
}

- (void)dealloc
{
    [_mutableImages release];
    [_documentModel release];
    [_pathToImageKeeperSupportDirectory release];
    [_defaultImages release];
    
    [super dealloc];
}

- (void)uploadImageForPath:(NSString *)path
{
    NSURL *imageURL = [NSURL fileURLWithPath:path];
    NSString *imageName = [[[imageURL pathComponents] lastObject] componentsSeparatedByString:@"."][0];
    NSImage *imageObj = [[NSImage alloc] initWithContentsOfURL:imageURL];
    
    imageObj.name = imageName;
    
    [self.mutableImages addObject:imageObj];
    
    [imageObj release];
}

- (NSString *)putToApplicationSupportDirectoryImage:(NSImage *)image withName:(NSString *)fileName
{
    NSData *imageData = [image TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    imageData = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];

    NSString *imageName = fileName;
    NSString *pathToImageKeeperSupportDirectory = [self pathToImageKeeperSupportDirectory];
    NSUInteger suffix = 1;

    while ([fileManager fileExistsAtPath:[pathToImageKeeperSupportDirectory stringByAppendingPathComponent:imageName]])
    {
        imageName = [NSString stringWithFormat:@"%@ %lu", kDefaultFileName, suffix];
        suffix++;
    }
    
    NSError *error = nil;
    [imageData writeToFile:[pathToImageKeeperSupportDirectory stringByAppendingPathComponent:imageName] options:NSDataWritingWithoutOverwriting error:&error];
    
    if (error)
    {
        NSLog(@"error creating image: %@", [error localizedDescription]);
    }
    
    return imageName;
}

- (NSString *)pathToImageKeeperSupportDirectory
{
    if (!_pathToImageKeeperSupportDirectory)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *applicationSupportDirectory = [paths firstObject];
        applicationSupportDirectory = [applicationSupportDirectory stringByAppendingPathComponent:kProductName];
        
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:applicationSupportDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        if (error)
        {
            NSLog(@"error creating directory: %@", [error localizedDescription]);
        }
        
        _pathToImageKeeperSupportDirectory = [applicationSupportDirectory retain];
    }
    return _pathToImageKeeperSupportDirectory;
}

- (void)selectElementInPoint:(NSPoint)point
{
    id<MELElement> newSelectedElement = [self.documentModel takeTopElementInPoint:point];
    
    if (newSelectedElement != self.selectedElement)
    {
        self.selectedElement = newSelectedElement;
    }
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

- (void)putToDocumentModelImageFromLibraryAtIndex:(NSUInteger)index toPoint:(NSPoint)point;
{
    NSImage *image = self.images[index];
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat x = point.x - image.size.width / 2;
    CGFloat y = point.y - image.size.height / 2;
    
    MELRect *frame = [[MELRect alloc] initWithX:x y:y width:width height:height];
    
    [self putToDocumentModelImage:image inFrame:frame];
    
    [frame release];
}

- (void)putToDocumentModelImage:(NSImage *)image inFrame:(MELRect *)frame
{
    NSUInteger layer = self.documentModel.elements.lastObject.layer + 1;
    
    MELImageModel *imageModel = [[MELImageModel alloc] initWithImage:image frame:frame layer:layer];
    
    [self.documentModel addElement:imageModel];
    
    [imageModel release];
}

- (void)putToDocumentModelElement:(id<MELElement>)element;
{
    element.layer = self.documentModel.elements.lastObject.layer + 1;
    
    [self.documentModel addElement:element];
}

#pragma mark - MELDocumentModel KVC Support

- (void)removeImage:(NSImage *)image
{
    [self removeObjectFromImagesAtIndex:[self.mutableImages indexOfObject:image]];
}

- (NSArray<NSImage *> *)images
{
    return [[(NSArray<NSImage *> *)self.mutableImages copy] autorelease];
}

- (NSUInteger)countOfImages
{
    return self.mutableImages.count;
}

- (id)objectInImagesAtIndex:(NSUInteger)index
{
    return self.mutableImages[index];
}

- (void)insertObject:(NSImage *)object inImagesAtIndex:(NSUInteger)index
{
    if (object)
    {
        [self.mutableImages insertObject:object atIndex:index];
        
        object.name = [self putToApplicationSupportDirectoryImage:object withName:kDefaultFileName];
    }
}

- (void)removeObjectFromImagesAtIndex:(NSUInteger)index
{
    if (![self.defaultImages containsObject:self.mutableImages[index]])
    {
        NSString *imagePath = [self.pathToImageKeeperSupportDirectory stringByAppendingPathComponent:[self.mutableImages[index] name]];
        NSError *error = nil;
        
        [self.mutableImages[index] setName:nil];
        
        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&error];

        if (error)
        {
            NSLog(@"error removing image: %@", [error localizedDescription]);
        }

        [self.mutableImages removeObjectAtIndex:index];
    }
}

@end

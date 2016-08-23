//
//  MELDataStore.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MELDataStore.h"
#import "MELImageModel.h"
#import "MELDocumentModel.h"
#import "MELRect.h"

static NSString *const kLproj = @"lproj";
static NSString *const kNib = @"nib";

@interface MELDataStore()

@property (retain) NSMutableArray<NSImage *> *mutableImages;
@property (assign) MELImageModel *selectedImage;

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
                
                NSImage *imageObj = [[NSImage alloc] initWithContentsOfURL:imageURL];
                
                imageObj.name = [[[imageURL pathComponents] lastObject] componentsSeparatedByString:@"."][0];
                
                [_mutableImages addObject:imageObj];
                
                [imageObj release];
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

- (void)selectImageInPoint:(NSPoint)point
{
    self.selectedImage = [self.documentModel takeTopImageInPoint:point];
}

- (void)deselectImage
{
    self.selectedImage = nil;
}

- (void)addImage:(NSImage *)image
{
    
}

- (void)removeImage:(NSImage *)image
{
    
}

#pragma mark - MELDocumentModel modification

- (void)putToDocumentModelImage:(NSImage *)image inFrame:(MELRect *)frame
{
    NSUInteger layer = self.documentModel.imagesToDraw.count + 1;
    
    [self.documentModel addImage:[[MELImageModel alloc] initWithImage:image frame:frame layer:layer]];
}

- (void)putToDocumentModelImageModel:(MELImageModel *)imageModel
{
    imageModel.layer = self.documentModel.imagesToDraw.count + 1;
    
    [self.documentModel addImage:imageModel];
}

#pragma mark - MELDataStoreGetters

- (NSArray<NSImage *> *)images
{
    return [[(NSArray<NSImage *> *)self.mutableImages copy] autorelease];
}

@end

//
//  MELImagePreviewModel.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/26/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELImagePreviewModel.h"
#import "Macros.h"

#import <Cocoa/Cocoa.h>

@interface MELImagePreviewModel()
{
    NSString *_name;
}

@end

@implementation MELImagePreviewModel

+ (instancetype)imagePreviewModelWithImage:(NSImage *)image name:(NSString *)name
{
    MELImagePreviewModel *imagePreviewModel = [[MELImagePreviewModel alloc] init];
    
    imagePreviewModel.image = image;
    imagePreviewModel.name = name;
    
    return [imagePreviewModel autorelease];
}

- (void)dealloc
{
    [_image release];
    [_name release];
    
    [super dealloc];
}

- (void)setName:(NSString *)name
{
    BOOL ok = [self.image setName:name];
    
    if (_name != name && name != nil && ok)
    {
        [_name release];
        _name = [name retain];
    }
}

- (NSString *)name
{
    return _name;
}

@end

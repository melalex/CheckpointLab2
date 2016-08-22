//
//  MELImageModel.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELImageModel.h"
#import "MELRect.h"
#import "Macros.h"

@implementation MELImageModel

- (instancetype)initWithImage:(NSImage *)image frame:(MELRect *)frame layer:(NSUInteger)layer;
{
    if (self = [self init])
    {
        _image = image;
        _frame = frame;
        _layer = layer;
    }
    return self;
}

@end

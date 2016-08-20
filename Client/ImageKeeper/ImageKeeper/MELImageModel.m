//
//  MELImageModel.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELImageModel.h"



@implementation MELImageModel

- (instancetype)initWithImage:(NSImage *)image frame:(NSRect)frame
{
    if (self = [self init])
    {
        _image = image;
        _frame = frame;
    }
    return self;
}

@end

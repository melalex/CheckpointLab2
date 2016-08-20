//
//  MELCanvas.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELCanvas.h"
#import "MELImageModel.h"

@implementation MELCanvas

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);

    [super drawRect:dirtyRect];
    
    for (MELImageModel *image in self.imagesToDraw)
    {
        [image.image drawInRect:image.frame fromRect:NSZeroRect operation:NSCompositeSourceAtop fraction:1.0f];
    }
}

- (BOOL)isFlipped
{
    return NO;
}

@end

//
//  MELImageModel.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MELRect;

@interface MELImageModel : NSObject

@property (readonly,retain) NSImage *image;
@property (retain, readonly) MELRect *frame;
@property  NSUInteger layer;

- (instancetype)initWithImage:(NSImage *)image frame:(MELRect *)frame layer:(NSUInteger)layer;

@end

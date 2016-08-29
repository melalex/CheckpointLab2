//
//  MELImageModel.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "MELElement.h"

@class MELRect;

@interface MELImageModel : NSObject<MELElement>

@property (readonly,retain) NSImage *image;

@property CGFloat transparency;

- (instancetype)initWithImage:(NSImage *)image frame:(MELRect *)frame layer:(NSUInteger)layer;

@end

//
//  MELCanvas.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MELImageModel;

@interface MELCanvas : NSView

@property (retain) NSArray<MELImageModel *> *imagesToDraw;

@end

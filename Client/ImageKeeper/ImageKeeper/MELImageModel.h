//
//  MELImageModel.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MELImageModel : NSObject

@property (readonly,retain) NSImage *image;
@property NSRect frame;
@property (readonly) NSUInteger *layer;

- (instancetype)initWithImage:(NSImage *)image frame:(NSRect)frame;

@end

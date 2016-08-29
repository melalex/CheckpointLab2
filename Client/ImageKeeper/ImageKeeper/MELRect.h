//
//  MELRect.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/21/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MELRect : NSObject<NSCoding>

@property CGFloat x;
@property CGFloat y;
@property CGFloat width;
@property CGFloat height;
@property CGFloat rotation;

@property (readonly) NSRect rect;
@property (readonly) NSRect rotateRect;

- (instancetype)initWithRect:(NSRect)rect;
- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

- (NSRect)rotateRectWithRotation:(CGFloat)rotation;

@end

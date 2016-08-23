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

@property (readonly) NSRect rect;

- (instancetype)initWithRect:(NSRect)rect;
- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

@end

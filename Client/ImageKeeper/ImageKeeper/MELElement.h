//
//  MELElement.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/23/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MELRect;
@class MELVisitor;

@protocol MELElement <NSObject, NSCoding>

@property (retain) MELRect *frame;
@property  NSUInteger layer;

- (void)acceptVisitor:(MELVisitor *)visitor;

@end

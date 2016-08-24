//
//  MELStrategy.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/23/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSView;
@class NSEvent;
@class MELDataStore;

@protocol MELStrategy <NSObject>

@property (assign) NSView *ownerView;
@property (assign) MELDataStore *dataStore;

- (void)mouseDownAction:(NSEvent *)theEvent;
- (void)mouseDraggAction:(NSEvent *)theEvent;
- (void)mouseUpAction:(NSEvent *)theEvent;

@end

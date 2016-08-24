//
//  MELStrategy.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/23/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MELDataStoreProtocols.h"

@class NSView;
@class NSEvent;

@protocol MELStrategy <NSObject>

@property (assign) NSView *ownerView;
@property (assign) id<MELCanvasModelController> dataStore;

- (void)mouseDownAction:(NSEvent *)theEvent;
- (void)mouseDraggAction:(NSEvent *)theEvent;
- (void)mouseUpAction:(NSEvent *)theEvent;

@end

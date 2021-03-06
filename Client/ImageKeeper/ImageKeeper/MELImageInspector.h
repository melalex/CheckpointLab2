//
//  MELImageInspector.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/21/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MELDataStoreProtocols.h"

@interface MELImageInspector : NSWindowController

@property (retain) id<MELImageInspectorModelController> dataStore;

@property CGFloat xCoordinate;
@property CGFloat yCoordinate;
@property CGFloat width;
@property CGFloat height;
@property NSUInteger elementLayer;

@property CGFloat rotation;
@property CGFloat transparency;

@property (readonly) BOOL isSelected;
@property (readonly) BOOL isFigure;

@end

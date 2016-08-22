//
//  MELImageInspector.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/21/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MELDataStore;

@interface MELImageInspector : NSWindowController

@property (retain) MELDataStore *dataStore;

@property CGFloat xCoordinate;
@property CGFloat yCoordinate;
@property CGFloat width;
@property CGFloat height;

@property (readonly) BOOL isSelected;

@end

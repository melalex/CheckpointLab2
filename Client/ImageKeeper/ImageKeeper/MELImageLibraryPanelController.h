//
//  MELImageLibraryPanelController.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MELDataStoreProtocols.h"


@interface MELImageLibraryPanelController : NSWindowController

@property (retain) id<MELImageLibraryPanelModelController> dataStore;

- (void)addImage:(NSImage *)image;

@end

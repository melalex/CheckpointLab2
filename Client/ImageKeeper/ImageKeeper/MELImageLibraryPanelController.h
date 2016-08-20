//
//  MELImageLibraryPanelController.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MELDataStore;

@interface MELImageLibraryPanelController : NSWindowController

@property (retain) MELDataStore *dataStore;
@property (retain, readonly) NSArray<NSImage *> *imagePreviewList;

@end

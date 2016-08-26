//
//  MELImageLibraryPanelController.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MELDataStoreProtocols.h"

@class MELImagePreviewModel;

@interface MELImageLibraryPanelController : NSWindowController

@property (retain) NSObject<MELImageLibraryPanelModelController> *dataStore;
@property (retain, readonly) NSArray<MELImagePreviewModel *> *imagePreviewList;

- (void)deleteSelectedRow;

@end

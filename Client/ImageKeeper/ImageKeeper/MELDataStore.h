//
//  MELDataStore.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MELElement.h"
#import "MELDataStoreProtocols.h"

@class MELDocumentModel;
@class MELRect;

@interface MELDataStore : NSObject<MELImageLibraryPanelModelController, MELCanvasModelController, MELImageInspectorModelController>

@property (readonly, retain) NSArray<NSImage *> *images;
@property (readonly, assign) id<MELElement> selectedElement;
@property (retain) MELDocumentModel *documentModel;

@end

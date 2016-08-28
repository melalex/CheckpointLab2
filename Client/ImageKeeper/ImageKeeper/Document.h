//
//  Document.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/19/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MELDataStoreProtocols.h"

@class MELCanvas;
@class MELCanvasController;

@interface Document : NSDocument

@property (retain) id<MELDocumentModelProtocol> dataStore;

- (void)setCanvasController:(MELCanvasController *)canvasController;

@end


//
//  MELLibraryTableView.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/24/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MELImageLibraryPanelController.h"

@interface MELLibraryTableView : NSTableView

@property (assign) MELImageLibraryPanelController *imageLibraryPanelController;

@end

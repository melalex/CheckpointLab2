//
//  MELTableView.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/25/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MELImageLibraryPanelController.h"

@interface MELTableView : NSTableView

@property (assign) MELImageLibraryPanelController *controller;

@end

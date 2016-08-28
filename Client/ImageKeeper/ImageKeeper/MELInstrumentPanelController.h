//
//  MELInstrumentPanelController.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/23/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MELChangeableStrategy.h"

@interface MELInstrumentPanelController : NSWindowController

@property (retain) id<MELChangeableStrategy> canvasController;

@end

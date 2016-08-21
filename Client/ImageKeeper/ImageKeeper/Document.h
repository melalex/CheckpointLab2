//
//  Document.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/19/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MELCanvas;

@interface Document : NSDocument

@property (assign) IBOutlet MELCanvas *canvas;

@end

